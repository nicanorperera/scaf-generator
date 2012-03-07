# -*- encoding : utf-8 -*-

require 'generators/prueba/atributo'

class PruebaGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  argument :name, :type => :string, :required => true, :banner => 'Nombre'
  argument :args, :type => :array , :default => []   , :banner => 'Atributos'

  class_option :orden   , :desc => 'Soporte para Ordenable.'          , :type => :boolean, :aliases => "-o", :default => false
  class_option :slug    , :desc => 'Soporte pare FriendlyId.'         , :type => :boolean, :aliases => "-i", :default => false
  class_option :archivo , :desc => 'Soporte para tener un archivo.', :type => :boolean, :aliases => "-a", :default => false

  
  def initialize(*arguments, &block)
    super
    
    @con_orden   = options.orden?
    @con_slug    = options.slug?
    @con_archivo = options.foto?

    @singular = @name.downcase
    @plural   = @singular.pluralize
    @class    = @name.camelize
    @classes  = @plural.camelize
    
    @singular_path  = "admin_#{@singular}_path"
    @plural_path    = "admin_#{@plural}_path"
    @new_path       = "new_admin_#{@singular}_path"
    @edit_path      = "edit_admin_#{@singular}_path"
    @reordenar_path = "reordenar_admin_#{@plural}_path"

    @atributos = []
    
    args.each do |arg|
      @atributos << Atributo.new(arg)
    end

    info #TODO: sacar de aca!.

  end
  
  def body
    template 'model.erb'     , "app/models/#{@singular}.rb"
    template 'migration.erb' , "db/migrate/#{fecha}_create_#{@plural}.rb"
    template 'controller.erb', "app/controllers/admin/#{@plural}_controller.rb"
    template 'helper.erb', "app/helpers/#{@plural}_helper.rb"
    
    %w[_form _mini_form edit index new].each do |action| 
    template "views/#{action}.erb", "app/views/admin/#{@plural}/#{action}.html.erb"
    end
    template "views/nombre.erb", "app/views/admin/#{@plural}/_#{@singular}.html.erb"
    
    # add_admin_route "\n    resources :#{@plural} do\n      post :reordenar, :on => :collection\n    end"
      
    template 'cargar.erb', "lib/tasks/cargar_#{@plural}.rake"
  end
  
  private
  
  # Agrega Ruta en namespace :admin
  def add_admin_route(ruta)
    inject_into_file 'config/routes.rb', ruta ,  :after => /namespace :admin do/ 
  end
  
  def self.next_migration_number(dirname) #:nodoc:
    if ActiveRecord::Base.timestamped_migrations
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    else
      "%.3d" % (current_migration_number(dirname) + 1)
    end
  end
  
  def fecha
    Time.now.utc.strftime("%Y%m%d%H%M%S")
  end
  
  # Este metodo es usado solo para testear.
  # TODO: Eliminar metodo.
  def info
    say "Singular:#{@singular}. Plural:#{@plural}. Class:#{@class}. Classes:#{@classes}"

    say '--- Opciones ---'
    say "Con Orden"   if @con_orden
    say "Con Slug"    if @con_slug
    say "Con Archivo" if @con_archivo

    say '--- Atributos ---'
    @atributos.each do |a|
      say a.show
    end
    
    say '--- Paths ---'
    say "singular_path  #{@singular_path}"
    say "plural_path    #{@plural_path}"
    say "new_path       #{@new_path}"
    say "edit_path      #{@edit_path}"
  end
    
end