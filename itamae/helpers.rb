require 'itamae/secrets'
node[:vault] = Itamae::Secrets(File.join(__dir__, 'vault'))

module RecipeHelper
  def include_role(name)
    path = File.expand_path("../../#{name}/default.rb", @recipe.path)
    include_recipe(path)
  end

  def include_cookbook(name)
    path = File.expand_path("../../../cookbooks/#{name}", @recipe.path)
    include_recipe(path)
  end
end

Itamae::Recipe::EvalContext.send(:include, RecipeHelper)
