class SourceView

  include React::Component

  required_param :author
  required_param :text

  def render
    div class: "source" do
      h2(class: "sourceAuthor") { author }
      div do
        text
      end
    end
  end

end
