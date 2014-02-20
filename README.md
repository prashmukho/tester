---
  tags: rspec testing for TDD, predicate matching, syntactic sugar, stubs and doubles
  languages: ruby
---

# Tester 

Write specs in ./spec/tester_spec.rb

Run with rspec in the root directory

## Concepts Covered

1. Test Driven Development and checking for state within objects to confirm correct initialization

2. Predicate matchers both built ('be_true') and custom made

3. Using helper methods like 'have' to compare the size of owned and unowned collections

4. Employing methods stubs, expectations, and test doubles in tandem

### Basic TDD

The following example group will ensure that each test object has an appropriately assigned ID:

```ruby
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

  it "allows an object to maintain a predefined state" do
    # expect(test.initialized_with_id?(1)).to be_true --> alternative
    expect(test).to be_initialized_with_id(1)
  end
end
```
The above technique can be used to check for any instance variable's correct assignment. 

An implicit call to subject will invoke TestModel.new (if it can) which assigns nil to @id though should has been deprecated.
```ruby
it { should be_initialized_with_id(nil) } 
```

This will be supported in later Rspec versions >= 3 using 'is_expected'.
```ruby
it { is_expected.to be_initialized_with_id(nil) }
```

### Predicate Matchers

- The following example group will use the built in predicate matcher 'be_true':

```ruby
describe "predicate magic" do  
  it "expects truth from the righteous" do
    this_condition = 3 > 2
    # expect(this_condition).to be(true) --> alternative
    expect(this_condition).to be_true
  end
end
```
'be_true' is applied as '== true' and will let the test pass if 'this_condition' evaluates to 'true'

- The following example group will use a custom predicate matcher 'be_greater_than':

```ruby
describe "predicate magic" do  
  it "overcomes all odds" do
    goku = 1000000000
    vegeta = 999999999
    # expect(vegeta.surpassed_by(goku)).to be_true --> alternative
    expect(vegeta).to be_surpassed_by(goku)
  end
end
```
'be_surpassed_by' is applied as 'surpassed_by?' to Vegeta and will let the test pass if 'Goku' is expected to surpass it (1 billion > 999999999)

### To Have and Have not

- The following example group will use the built in predicate matcher 'have':

```ruby
describe "have whatever you like", :focus => true do
  it "allows a string to have a fixed number of characters" do
    this_string = "OOPs"
    # expect(this_string.length).to eq(4) --> alternative
    expect(this_string).to have(4).characters
  end
end
```
'#characters' is not defined for String class but it works all the same. For primitive data types 'have' will have first check to see if the class object responds to '#characters' but if it doesn't it simply applies '#size' or '#length'. 

- This technique works with arrays and hashes as well:

```ruby
describe "have whatever you like", :focus => true do
  it "allows an array to have a fixed number of things" do
    this_array = [1,2,3]
    # expect(this_array.size).to eq(3) --> alternative
    expect(this_array).to have(3).things
  end

  it "allows a hash to have a fixed number of key-value pairs" do
    this_hash = {:a=> 1, :b=> 2, :c=> 3}
    # expect(this_hash.size).to eq(3) --> alternative
    expect(this_hash).to have(3).key_value_pairs
  end
end
```
Neither 'Array#things' nor 'Hash#key_value_pairs' is defined but the tests will pass because both arrays and hases respend to '#size'.

- This technique also works with objects we create:

```ruby
describe "have whatever you like", :focus => true do
  class SoccerTeam
    attr_reader :players

    def initialize
      @players = Array.new(11) { nil }
    end
  end

  it "allows a soccer team to have a fixed number (11) of players" do
    any_soccer_team = SoccerTeam.new
    # expect(this_soccer_team.players.size).to eq(11) --> alternative # 1 - original formulation
    # expect(this_soccer_team.players).to have(11).players --> alternative # 2 - default have formulation
    expect(any_soccer_team).to have(11).players
  end
end
```
Here since 'SoccerTeam#players' (attr_reader) is defined and it returns the players array. So 'have' will apply '#players' to any_soccer_team before applying '#size' to the result to get 11.

### To Be What You Want To Be

A test double is ANYTHING literally. Once created it can stand in for any object. Below is an example group which uses a test double and a method stub to remove dependencies:

```ruby
describe "shady dealings with dopplegangers" do
  # Peter Russo must die
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
```
First we create a victim object called peter for 'Peter Russo' using '#let'. We then create a test double 'frank_the_assassin' referred to as 'Frank Underwood' in the test output. The second argument to '#double()' in the first 'it' block is a method stub which returns the value 'Frank Underwood' when the stubbed (dummy) method '#name' is called on it even though no such method actually exists. '#name' does exist in class 'Person', and its children, but the double does not inherit from it.

The true power of doubles comes from their ability to take a method stub and return whatever we want for the purpose of using the return value in another method call. In the second 'it' block, the expectation raises an error whereas in the first it does not. This is because '@name' in 'Killer' class is shielded from outside view and so it cannot be used. No matter, we can just use a test double which will ignore the inner workings of the 'Killer' class and check to see if the test involving 'be_killed_by' passes with the dummy killer's (frank_the_assassin) name set to 'Frank Underwood' and returned by its copy of '#name'.

Using test doubles encourages the integration of all the models by reducing coupling between tests and making them less brittle. They allow EVERY test to be run or written COMPLETELY in isolation without ANY dependencies - the Holy Grail of unit testing.









  