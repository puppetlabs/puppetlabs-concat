require 'etc'

Facter.add("concat_usergroup") do
    setcode do
        user = Etc.getpwnam(Facter.value('id'))
        Etc.getgrgid(user.gid).name
    end
end
