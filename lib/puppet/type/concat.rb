require 'puppet/type/file/owner'
require 'puppet/type/file/group'
require 'puppet/type/file/mode'
require 'puppet/util/checksums'

Puppet::Type.newtype(:concat) do
  @doc = "Gets all the file fragments and puts these into the target file.
    This will mostly be used with exported resources.

    example:
      Concat_fragment <<| tag == 'unique_tag' |>>

      concat { '/tmp/file':
        tag            => 'unique_tag', # Mandatory
        path           => '/tmp/file',  # Optional. If given it overrides the resource name
        owner          => 'root',       # Optional. Default to undef
        group          => 'root',       # Optional. Default to undef
        mode           => '0644'        # Optional. Default to undef
        order          => 'numeric'     # Optional, Default to 'numeric'
        ensure_newline => false         # Optional, Defaults to false
      }
  "
  ensurable do
    defaultvalues

    defaultto { :present }
  end

  def exists?
    self[:ensure] == :present
  end

  newparam(:name, :namevar => true) do
    desc "Resource name"
  end

  newparam(:tag) do
    desc "Tag reference to collect all concat_fragment's with the same tag"
    defaultto do
      resource.value(:name).gsub(/[\/:\n\s\(\)]/, '_')
    end
  end

  newparam(:path) do
    desc "The output file"
    defaultto do
      resource.value(:name)
    end
    validate do |path|
      unless Puppet::Util.absolute_path?(path, :posix) or Puppet::Util.absolute_path?(path, :windows)
        raise Puppet::ResourceError, "#{path.inspect} is not an absolute path."
      end
    end
  end

  newparam(:owner, :parent => Puppet::Type::File::Owner) do
    desc "Desired file owner."
    validate do |owner|
      unless owner.is_a?(String)
        raise Puppet::ResourceError, "owner parameter #{owner} is not a string"
      end
    end
  end

  newparam(:group, :parent => Puppet::Type::File::Group) do
    desc "Desired file group."
    validate do |group|
      unless group.is_a?(String)
        raise Puppet::ResourceError, "group parameter #{group} is not a string"
      end
    end
  end

  newparam(:mode, :parent => Puppet::Type::File::Mode) do
    desc "Desired file mode."
    validate do |mode|
      unless mode.is_a?(String)
        raise Puppet::ResourceError, "mode parameter #{mode} is not a string"
      end
    end
  end

  newparam(:order) do
    desc "Controls the ordering of fragments. Can be set to alphabetical or numeric."
    defaultto 'numeric'
    validate do |order|
      unless ['alpha', 'numeric'].include?(order)
        raise Puppet::ResourceError, "invalid order parameter #{order}; valid values are [alpha, numeric]"
      end
    end
  end

  newparam(:backup) do
    desc "Controls the filebucketing behavior of the final file and see File type reference for its use."
    defaultto 'puppet'
    validate do |backup|
      unless [String, TrueClass, FalseClass].include?(backup.class)
        raise Puppet::ResourceError, "invalid backup parameter #{backup.inspect}; must be string or bool"
      end
    end
  end

  newparam(:replace) do
    desc "Whether to replace a file that already exists on the local system."
    defaultto true
    validate do |replace|
      unless [TrueClass, FalseClass].include?(replace.class)
        raise Puppet::ResourceError, "invalid replace parameter #{replace.inspect}; is not a boolean"
      end
    end
  end

  newparam(:validate_cmd) do
    desc "Validates file."
    validate do |validate_cmd|
      unless validate_cmd.kind_of?(String)
        raise Puppet::ResourceError, "invalid validate_cmd parameter #{validate_cmd.inspect}; is not a string"
      end
    end
  end

  newparam(:ensure_newline) do
    desc "Whether to ensure there is a newline after each fragment."
    defaultto false
    validate do |ensure_newline|
      unless [TrueClass, FalseClass].include?(ensure_newline.class)
        raise Puppet::ResourceError, "invalid ensure_newline parameter #{ensure_newline.inspect}; is not a boolean"
      end
    end
  end

  autorequire(:concat_fragment) do
    catalog.resources.collect do |r|
      if r.is_a?(Puppet::Type.type(:concat_fragment)) && r[:tag] == self[:tag]
        r.name
      end
    end.compact
  end

  # Autorequire the file we are generating below
  autorequire(:file) do
    [self[:path]]
  end

  def should_content
    return @generated_content if @generated_content
    @generated_content = ""
    content_fragments = []

    resources = catalog.resources.select do |r|
      r.is_a?(Puppet::Type.type(:concat_fragment)) && r[:tag] == self[:tag]
    end

    resources.each do |r|
      content_fragments << ["#{r[:order]}___#{r[:name]}", fragment_content(r)]
    end

    if self[:order] == 'numeric'
      sorted = content_fragments.sort do |a, b|
        def decompound(d)
          d.split('___').map { |v| v =~ /^\d+$/ ? v.to_i : v }
        end

        decompound(a[0]) <=> decompound(b[0])
      end
    else
      sorted = content_fragments.sort do |a, b|
        def decompound(d)
          d.split('___').first
        end

        decompound(a[0]) <=> decompound(b[0])
      end
    end

    @generated_content = sorted.map { |cf| cf[1] }.join

    @generated_content
  end

  def fragment_content(r)
    if r[:content].nil? == false
      fragment_content = r[:content]
    elsif r[:source].nil? == false
      @source = nil
      Array(r[:source]).each do |source|
        if Puppet::FileServing::Metadata.indirection.find(source)
          @source = source 
          break
        end
      end
      self.fail "Could not retrieve source(s) #{r[:source].join(", ")}" unless @source
      tmp = Puppet::FileServing::Content.indirection.find(@source, :environment => catalog.environment)
      fragment_content = tmp.content unless tmp.nil?
    end

    if self[:ensure_newline]
      fragment_content<<"\n" unless fragment_content =~ /\n$/
    end

    fragment_content
  end

  def generate
    file_opts = {
      :ensure => self[:ensure] == :absent ? :absent : :file,
    }

    [:path, :owner, :group, :mode, :replace, :backup].each do |param|
      unless self[param].nil?
        file_opts[param] = self[param]
      end
    end

    file = Puppet::Type.type(:file).new(file_opts)
    catalog.add_resource(file)
    catalog.relationship_graph.add_relationship(self,file)
    deps = catalog.relationship_graph.dependents(self).map(&:builddepends)
    [deps,self.builddepends].flatten.each do |edge|
      newedge = edge.dup
      if newedge.source == self
        newedge.source = catalog.resource("File[#{self[:path]}]")
        catalog.relationship_graph.add_edge(newedge)
      elsif newedge.target == self
        newedge.target = catalog.resource("File[#{self[:path]}]")
        catalog.relationship_graph.add_edge(newedge)
      end
    end
    []
  end

  def eval_generate
    content = should_content

    if !content.nil? and !content.empty?
      catalog.resource("File[#{self[:path]}]")[:content] = content
    end
    []
  end
end
