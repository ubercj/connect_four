class Player
  attr_accessor :name, :marker
  def initialize
    @name = ""
    @marker = ""
  end

  def collect_name
    @name = gets.chomp
  end

  def collect_marker
    @marker = gets.chomp
  end
end