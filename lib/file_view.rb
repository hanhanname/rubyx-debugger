class FileView < ElementView


  def draw
    @element = div(".file_view") << div("h4" ,"Future")
  end

end
