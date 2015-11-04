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
      div("button.crawl" , "Crawl") <<
      div("button.run" , "Run") <<
      div("button.wizz" , "Wizz") <<
      div( "br") <<
      div("span.clock" , clock_text) <<
      div( "br") <<
      div("span.state" ,  state_text) <<
      div( "br" , "Stdout") <<
      div("span.stdout")
    # set up event handler
    @element.at_css(".act").on("click") { self.update }
    @element.at_css(".crawl").on("mousedown") { self.start( 0.5 ) }
    @element.at_css(".run").on("mousedown") { self.start( 0.1 ) }
    @element.at_css(".wizz").on("mousedown") { self.start( 0.05 ) }
    @element.at_css(".crawl").on("mouseup") { self.stop }
    @element.at_css(".run").on("mouseup") { self.stop }
    @element.at_css(".wizz").on("mouseup") { self.stop }
    return @element
  end


  def start(speed)
    @running = speed
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
      proc.after( @running )
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
    @element.at_css(".state").text = state_text
    @element.at_css(".stdout").text = @interpreter.stdout
  end

  def state_text
    "State #{@interpreter.state}"
  end

  def clock_text
    "Instruction #{@interpreter.clock}"
  end
end
