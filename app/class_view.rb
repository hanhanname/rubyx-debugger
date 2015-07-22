class ClassView

  include React::Component

  required_param :sources, type: [Hash]

  def render
    div class: "sourceList" do
      sources.each do |source|
        SourceView author: source[:author], text: source[:text]
      end
    end
  end

end
