class FileView < ElementView


  def draw
    DOM do |dom|
      dom.div.file_view do
        dom.h4 {"Future"}
      end
    end
  end

end
