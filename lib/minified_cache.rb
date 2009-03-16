module ActionView::Helpers::AssetTagHelper
  class AssetCollection
	  def write_asset_file_contents(joined_asset_path)
	    FileUtils.mkdir_p(File.dirname(joined_asset_path))
	    # start monkey-patch
	    jsmin = File.join(File.dirname(__FILE__), '/jsmin.rb')
	    tmp = Tempfile.new('src_js')
	    tmp.print(joined_contents)
	    tmp.rewind
	    minified = Tempfile.new('minified')
	    %x[ruby #{jsmin} < #{tmp.path} > #{minified.path}]
	    File.open(joined_asset_path, "w+") { |cache| cache.write(minified.read) }
	    # end monkey-patch
	    # REPLACED: File.open(joined_asset_path, "w+") { |cache| cache.write(joined_contents) }
	    mt = latest_mtime
	    File.utime(mt, mt, joined_asset_path)
	  end
	end
end