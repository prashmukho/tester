require_relative './spec_helper'

describe "commandments", :focus => true do
  
  describe "predicate magic" do
    
    it "expects truth from the righteous" do
      this_condition = 3 > 2
      # expect(this_condition).to be(true)
      expect(this_condition).to be_true
    end

    it "rejects lies from the unworthy" do
      this_condition = 3 > 4
      # expect(this_condition).to be(false)
      expect(this_condition).to be_false
    end

    class Fixnum
      def surpassed_by?(num)
        self < num
      end
    end

    it "overcomes all odds" do
      goku = 1000000000
      vegeta = 999999999
      # expect(vegeta.surpassed_by(goku)).to be_true --> alternative
      expect(vegeta).to be_surpassed_by(goku)
    end

    class SentientBeing
      attr_reader :type

      def initialize(type)
        type == "God" || "god".downcase ? @type = "Divine" : @type = "Mortal"
      end

      def more_enlightened_than?(being)
        self.type < being.type
      end
    end

    it "tempts fate" do
      god = SentientBeing.new("God")
      man = SentientBeing.new("Man")

      # expect(man).to_not be_more_enlightened_than(god)

      # method expectation as an infinite knowledge multiplier
      expect(man).to receive(:more_enlightened_than?).and_return(true)
      expect(man).to be_more_enlightened_than(god)

      # pride comes before the fall
      proud_man = double('proud man', :humbled? => true)
      expect(proud_man).to be_humbled
    end

    class Condition
      attr_reader :condition

      def initialize(condition)
        @condition = condition
      end

      def confusing?
        self.condition == true
      end
    end

    it "understands its limitations" do
      this_condition = Condition.new(true || false && true)
      # expect(this_condition.condition).to be(true)
      expect(this_condition).to be_confusing
    end

    class Repairman
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def the_truest_repairman?
        @name == "Troy"
      end
    end

    it "allows only one to be the truest" do
      troy = Repairman.new("Troy")
      # expect(troy.name == "Troy").to be_true
      expect(troy).to be_the_truest_repairman
    end
  end

  describe "have whatever you like", :focus => true do
    it "allows a string to have a fixed number of characters" do
      this_string = "OOPs"
      # expect(this_string.length).to eq(4)
      expect(this_string).to have(4).characters
    end

    it "allows an array to have a fixed number of things" do
      this_array = [1,2,3]
      # expect(this_array.size).to eq(3)
      expect(this_array).to have(3).things
    end

    it "allows a hash to have a fixed number of key-value pairs" do
      this_hash = {:a=> 1, :b=> 2, :c=> 3}
      # expect(this_hash.size).to eq(3)
      expect(this_hash).to have(3).key_value_pairs
    end

    class SoccerTeam
      attr_reader :players

      def initialize
        @players = Array.new(11) { nil }
      end
    end

    it "allows a soccer team to have a fixed number (11) of players" do
      any_soccer_team = SoccerTeam.new
      # expect(this_soccer_team.players.size).to eq(11) 
      # expect(this_soccer_team.players).to have(11).players
      expect(any_soccer_team).to have(11).players
    end
  end

  class TestModel
    IDs = []

    def initialize(id=nil)
      @id = id
      IDs << id unless IDs.include?(id) || id.nil?
    end

    def initialized_with_id?(id)
      @id == id
    end
  end

  describe "check for state with conviction", :focus => true do
    subject(:test) { TestModel.new(1) }

    # it { should be_initialized_with_id(nil) } #—> deprecated, what?!
    # it { is_expected.to be_initialized_with_id(nil) } #—> in Rspec 3, :(

    it "allows an object to maintain a predefined state" do
      # expect(test.initialized_with_id?(1)).to be_true
      expect(test).to be_initialized_with_id(1)
    end
  end

  describe "shady dealings with dopplegangers" do
    class Person
      attr_reader :name

      def initialize(name)
        @name = name
      end
    end

    class Victim < Person
      def killed_by?(killer)
        raise "killer’s name is unknown" if killer.is_a?(Killer)

        (self.name == "Peter Russo") && (killer.name == "Frank Underwood")
      end
    end

    class Killer < Person
      def initialize(name="unknown")
        @name = name
      end

      def name
        "unknown"
      end
    end

    # Peter Russon must die
    let(:peter) { Victim.new("Peter Russo") }

    it "does what needs doing" do
      # Frank has seen what he must become to kill men like Russo
      frank_the_assassin = double('Frank the assassin', :name => 'Frank Underwood')
      expect(peter).to be_killed_by(frank_the_assassin)
    end

    it "leaves no traces behind" do
      # The deed is done and gone is the dagger
      frank = Killer.new("Frank Underwood")
      expect{peter.killed_by?(frank)}.to raise_error("killer’s name is unknown")
    end
  end
end

# - As I walk through the valley of the shadow of Rails, I fear no Rspec.