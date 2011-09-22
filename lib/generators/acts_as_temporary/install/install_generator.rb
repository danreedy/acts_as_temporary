require 'rails/generators/migration'

module ActsAsTemporary
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)
      desc "Add the migrations needed for acts_as_temporary to work"

      def self.next_migration_number(path)
        unless @prev_migration_nr
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        else
          @prev_migration_nr += 1
        end
        @prev_migration_nr.to_s
      end

      def copy_migrations
        migration_template "create_temporary_objects.rb", "db/migrate/create_temporary_objects.rb"
      end

    end
  end
end