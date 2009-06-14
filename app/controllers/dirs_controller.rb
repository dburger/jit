class DirsController < ApplicationController

  def show
    respond_to do |format|
      format.json {
        subtree_hash = path_to_subtree_hash(params[:path])
        render :json => subtree_hash
      }
    end
  end

  private

  def path_to_subtree_hash(path)
    path = '' if path == 'root'
    path = File.expand_path(File.join(Rails.root, path))
    path = Rails.root if !path.starts_with?(Rails.root)
    dirs = Dir[File.join(path, '*')]
    prefix_len = Rails.root.length + 1
    stripped_dirs = dirs.map {|d| d[prefix_len, d.length]}
    subtree_hash = path_to_hash(path)
    stripped_dirs.each {|sd| subtree_hash[:children] << path_to_hash(sd)}
    subtree_hash
  end

  def path_to_hash(path)
    {
      :id => path,
      :name => path,
      :data => {},
      :children => []
    }
  end

end
