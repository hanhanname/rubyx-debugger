require "browser/delay"

class StatusView < ElementView

  def initialize interpreter
    @interpreter = interpreter
    @running = false
  end

  def draw
    header = div("h4" , "Interpreter" )
    header <<  div("span.header_state" ,  state_text)
    @element = div(".status_view") <<
      header <<
      div("button.next" , "Next") <<
      div("button.run" , "Run") <<
      div("button.wizz" , "Wizz") <<
      div( "br") <<
      div("span.clock" , clock_text) <<
      div( "br") <<
      div("span.flags" ,  flags_text) <<
      div( "br") <<
      div( "span.stdout" , "Stdout") <<
      div( "br") <<
      div( "span.status" , "Status")
    # set up event handler
    @element.at_css(".next").on("click") { self.update }
    @element.at_css(".run").on("mousedown") { self.start( 0.1 ) }
    @element.at_css(".wizz").on("mousedown") { self.start( 0.0 ) }
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
    proc = Proc.new do
      self.update
      self.run
    end
    proc.after( @running )
  end
  def update
    @interpreter.tick
    @element.at_css(".clock").text = clock_text
    @element.at_css(".header_state").text = state_text
    @element.at_css(".flags").text = flags_text
    @element.at_css(".stdout").text = @interpreter.stdout
    @element.at_css(".status").text = status_text
  end

  def status_text
    return "#{@interpreter.instruction.to_s}" unless @interpreter.instruction.source
    source = @interpreter.instruction.source
    s = "#{source.to_s}"
    if( source.respond_to?(:source) and source.source )
      s += @interpreter.instruction.source.source.to_s
    end
    s
  end
  def state_text
    " (#{@interpreter.state})"
  end

  def flags_text
    flags = []
    @interpreter.flags.each do |name,value|
      flags << name if value
    end
    "Flags #{flags.join(':')}"
  end

  def clock_text
    "Instruction #{@interpreter.clock}-0x#{@interpreter.pc.to_s(16)}"
  end
end
