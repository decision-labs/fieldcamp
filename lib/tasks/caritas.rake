namespace :caritas do
  namespace :postgis do
    desc "installs the postgis environment"
    task :install do
      %x[sh ./script/postgis_setup.sh]
    end

    desc "uninstalls the postgis environment"
    task :uninstall do
      %x[sh ./script/postgis_teardown.sh]
    end
  end
end

