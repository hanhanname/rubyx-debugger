require "browser/delay"

class StatusView < ElementView

  def initialize interpreter
    @interpreter = interpreter
    @running = false
  end

  def draw
    @element = div(".status_view") <<
    div("h4" , "Interpreter" ) <<
      div("button.act" , "Next") <<
      div("button.run" , "Run") <<
      div( "br") <<
      div("span.clock" , clock_text) <<
      div( "br") <<
      div("span.state" ,  state_text) <<
      div( "br")  <<
      div( "span.link" , link_text) <<
      div( "br" , "Stdout") <<
      div("span.stdout")
    # set up event handler
    @element.at_css(".act").on("click") { self.update }
    @element.at_css(".run").on("mousedown") { self.start }
    @element.at_css(".run").on("mouseup") { self.stop }
    return @element
  end


  def start
    @running = true
    run
  end
  def stop
    @running = false
  end
  def run
    return unless @running
    begin
      proc = Proc.new do
        self.update
        self.run
      end
      proc.after( 0.1 )
    rescue => e
      puts e
    end
  end
  def update
    begin
      @interpreter.tick
    rescue => e
      puts e
    end
    @element.at_css(".clock").text = clock_text
    @element.at_css(".link").text = link_text
    @element.at_css(".state").text = state_text
    @element.at_css(".stdout").text = @interpreter.stdout
  end

  def link_text
    "Link #{@interpreter.link}"
  end

  def state_text
    "State #{@interpreter.state}"
  end

  def clock_text
    "Instruction #{@interpreter.clock}"
  end
end
