require 'puppet/type/file/owner'
require 'puppet/type/file/group'
require 'puppet/type/file/mode'
require 'puppet/util/checksums'

Puppet::Type.newtype(:concat_file) do
  @doc = "Gets all the file fragments and puts these into the target file.
    This will mostly be used with exported resources.

    example:
      Concat_fragment <<| tag == 'unique_tag' |>>

      concat_file { '/tmp/file':
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

    # Workaround for PUP-1963 (https://tickets.puppetlabs.com/browse/PUP-1963)
    #
    # Because notify/subscribe relationships are not propogated through to
    # generated resources, the insync status of the concat_file resource is
    # configured to be whether or not the generated file resource is insync.
    # This will result in subscribe relationships working correctly.
    def insync?(is)
      # Determine if there are changes pending to the generated file resource
      generated_file = resource.catalog.resource("File[#{@resource[:path]}]")
      current_values = generated_file.retrieve_resource.to_hash
      pending_change = generated_file.properties.any? do |property|
        current_value = current_values[property.name]
        property.should && !property.safe_insync?(current_value) ? true : false
      end

      # If no changes are pending, then the concat resource is in sync
      !pending_change
    end

    # The generated file resource will perform the relevant work
    def sync; end

    # When any resource is synchronized an event is logged. In the case of the
    # PE-1963 workaround the concat_file event is really just an event proxy
    # for the associated change that will be made to the generated file
    # resource, so the event text should be adjusted to reflect that.

    def change_to_s(currentvalue, newvalue)
      "concat file will be updated"
    end

    def is_to_s(value)
      "is incorrect"
    end

    def should_to_s(value)
      "updated"
    end
  end

  def exists?
    self[:ensure] == :present
  end

  newparam(:name, :namevar => true) do
    desc "Resource name"
  end

  newparam(:tag) do
    desc "Tag reference to collect all concat_fragment's with the same tag"
  end

  newparam(:path) do
    desc "The output file"
    defaultto do
      resource.value(:name)
    end
  end

  newparam(:owner, :parent => Puppet::Type::File::Owner) do
    desc "Desired file owner."
  end

  newparam(:group, :parent => Puppet::Type::File::Group) do
    desc "Desired file group."
  end

  newparam(:mode, :parent => Puppet::Type::File::Mode) do
    desc "Desired file mode."
  end

  newparam(:order) do
    desc "Controls the ordering of fragments. Can be set to alphabetical or numeric."
    defaultto 'numeric'
  end

  newparam(:backup) do
    desc "Controls the filebucketing behavior of the final file and see File type reference for its use."
    defaultto 'puppet'
  end

  newparam(:replace) do
    desc "Whether to replace a file that already exists on the local system."
    defaultto true
  end

  newparam(:validate_cmd) do
    desc "Validates file."
  end

  newparam(:ensure_newline) do
    desc "Whether to ensure there is a newline after each fragment."
    defaultto false
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

    [Puppet::Type.type(:file).new(file_opts)]
  end

  def eval_generate
    content = should_content

    if !content.nil? and !content.empty?
      catalog.resource("File[#{self[:path]}]")[:content] = content
    end
    []
  end
end
