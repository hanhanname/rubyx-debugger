class RegisterView

  include React::Component
  required_param :submit_source, type: Proc

  define_state :author, :text

  def render
    div do
      div do
        "Author: ".span
        input(type: :text, value: author, placeholder: "Your name", style: {width: "30%"}).
          on(:change) { |e| author! e.target.value }
      end
      div do
        div(style: {float: :left, width: "50%"}) do
          textarea(value: text, placeholder: "Say something...", style: {width: "90%"}, rows: 10).
            on(:change) { |e| text! e.target.value }
        end
        div(style: {float: :left, width: "50%"}) do
          text
        end
      end
      button { "Post" }.on(:click) { submit_source :author => (author! ""), :text => (text! "") }
    end
  end
end
