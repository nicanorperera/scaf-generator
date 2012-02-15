require 'rails/generators/generated_attribute'

class ScafGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  no_tasks { attr_accessor :scaffold_name, :attributes}
  argument :scaffold_name, :type => :string, :required => true
  argument :arguments, :type => :array, :default => [], :banner => 'attributes'

  def initialize(*args, &block)
    super

    # Inicializa la variable de instancia @attributos a partir de los argumentos
    obtener_atributos
    
    # Genera un Controller
    generate "controller", "#{plural_name} --no-assets"
    
    # Genera un Scaffold sin Controller ni Vistas ni Assets
    generate("scaffold", "#{scaffold_name} #{arguments.join(' ')} --no-scaffold-controller --no-assets")

    # Agrega controller de administracion en controllers/admin/
    template 'admin_controller.rb', "app/controllers/admin/#{plural_name}_controller.rb"
    
    # Agrega Vistas en views/admin/
    %w[index new edit _formulario].each do |action| 
      template "views/#{action}.html.erb", "app/views/admin/#{plural_name}/#{action}.html.erb"
    end
    template "views/nombre.html.erb", "app/views/admin/#{plural_name}/_#{singular_name}.html.erb"

    # Agrega Ruta en namespace :admin
    inject_into_file 'config/routes.rb', "\n    resources :#{plural_name}" ,  :after => /namespace :admin do/ 
  end

  private

  def obtener_atributos
    @attributes = []
    
    arguments.each do |arg|
      @attributes << Rails::Generators::GeneratedAttribute.new(*arg.split(':'))
    end

    @attributes.uniq!
  end

 
  def singular_name; scaffold_name.underscore; end
  def plural_name; scaffold_name.underscore.pluralize; end
 
  def table_name; end

  def class_name; scaffold_name.split('::').last.camelize; end
  def model_path; class_name.underscore; end
  def plural_class_name; plural_name.camelize; end

  def item; singular_name.split('/').last; end
  def items; item.pluralize; end
  
  def item_resource; scaffold_name.underscore.gsub('/','_'); end

  def admin_items_path; "admin_#{items_path}"; end

  def items_path;   "#{items}_path";            end

  def admin_item_path;  "admin_#{item}_path";       end
  def admin_items_path; "admin_#{items}_path";      end

  def admin_show_path; admin_item_path; end
  def admin_index_path; admin_items_path; end
  def admin_new_path;    "new_admin_#{item}_path";   end
  def admin_edit_path;   "edit_admin_#{item}_path";  end

end
