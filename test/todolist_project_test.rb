require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require "minitest/reporters"
require 'bundler/setup'
Minitest::Reporters.use!

require_relative '../lib/todolist_project'

class TodoListTest < MiniTest::Test

  def setup
    @todo1 = Todo.new("Buy milk")
    @todo2 = Todo.new("Clean room")
    @todo3 = Todo.new("Go to gym")
    @todos = [@todo1, @todo2, @todo3]

    @list = TodoList.new("Today's Todos")
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
  end

  # Your tests go here. Remember they must start with "test_"

  def test_size
    assert_equal(3, @list.size)
  end

  def test_first
    assert_equal(@todo1, @list.first)
  end

  def test_last
    assert_equal(@todo3, @list.last)
  end

  def test_shift
    todo = @list.shift
    assert_equal(@todo1, todo)
    assert_equal([@todo2, @todo3], @list.to_a)
  end

  def test_pop
    todo = @list.pop
    assert_equal(@todo3, todo)
    assert_equal([@todo1, @todo2], @list.to_a)
  end

  def test_done?
    assert(@list.done? == false)

    @todo1.done!
    @todo2.done!
    @todo3.done!

    assert_equal(@list.done?, true)
  end

  def test_add_type_error
    assert_raises(TypeError) {@list.add(5)}
  end

  def test_shovel
    todo4 = Todo.new("Test a shovel")
    @list << todo4
    assert_equal(4, @list.size)
  end

  def test_add
    todo4 = Todo.new("Test an add")
    @list.add(todo4)
    assert_equal(4, @list.size)
  end

  def test_item_at
    assert_equal(@list.item_at(0), @todo1)
    assert_raises(IndexError) {@list.item_at(5)}
  end

  def test_mark_done_at
    @list.mark_done_at(0)
    assert(@todo1.done?)

    assert_raises(IndexError) {@list.mark_done_at(5)}
  end

  def test_mark_undone_at
    @list.mark_done_at(0)
    @list.mark_undone_at(0)
    refute(@todo1.done?)

    assert_raises(IndexError) {@list.mark_undone_at(5)}
  end

  def test_done!
    @list.done!
    assert(@list.done?)
  end

  def test_remove_at
    @list.remove_at(0)
    refute_includes(@list.todos, @todo1)
    assert_raises(IndexError) {@list.remove_at(7)}
  end

  def test_to_s
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [ ] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT

    assert_equal(output, @list.to_s)
  end

  def test_to_s_one_done
    @todo1.done!
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT

    assert_equal(output, @list.to_s)
  end

  def test_to_s_all_done
    @list.done!
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [X] Clean room
    [X] Go to gym
    OUTPUT

    assert_equal(output, @list.to_s)
  end

  def test_each
    @list.each do |item|
      item.done!
    end
    assert(@list.done?)
  end

  def test_each_return_value
    return_value = @list.each do |item|
      item.done!
    end
    assert_equal(@list, return_value)
  end

  def test_select
    @todo1.done!
    return_value = @list.select do |item|
      item.done?
    end
    assert_instance_of(TodoList, return_value)
    assert_equal([@todo1], return_value.to_a)
  end

end