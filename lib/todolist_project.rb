require 'bundler/setup'
require 'stamp'

class Todo
  DONE_MARKER = 'X'
  UNDONE_MARKER = ' '

  attr_accessor :title, :description, :done, :due_date

  def initialize(title, description='')
    @title = title
    @description = description
    @done = false
  end

  def done!
    self.done = true
  end

  def done?
    done
  end

  def undone!
    self.done = false
  end

  def to_s # replaces original #to_s method
      result = "[#{done? ? DONE_MARKER : UNDONE_MARKER}] #{title}"
      result += due_date.stamp(' (Due: Friday January 6)') if due_date
      result
  end
end

class TodoList
  attr_accessor :title, :todos

  def initialize(title)
    @title = title
    @todos = []
  end

  def <<(item)
    if is_todo_object?(item)
      self.todos << item
    else
      raise TypeError.new("Can only add ToDo objects.")
    end
  end

  def add (item)
    self << item
  end

  def size
    self.todos.size
  end

  def first
    self.todos.first
  end

  def last
    self.todos.last
  end

  def done?
    self.todos.all? { |item| item.done? }
  end

  def item_at(index)
    if self.todos[index]
      self.todos[index]
    else
      raise IndexError.new
    end
  end

  def mark_done_at(index)
    raise IndexError.new unless self.todos[index]

    self.todos[index].done!
  end

  def mark_undone_at(index)
    raise IndexError.new unless self.todos[index]

    self.todos[index].undone!
  end

  def done!
    self.todos.each_with_index do |el, index|
      mark_done_at(index)
    end
  end

  def shift
    self.todos.shift
  end

  def pop
    self.todos.pop
  end

  def remove_at(index)
    raise IndexError.new unless self.todos[index]

    self.todos.delete_at(index)
  end

  def to_s
    text = "---- #{title} ----\n"
    text << @todos.map(&:to_s).join("\n")
    text
  end

  def to_a
    self.todos
  end

  def each
    counter = 0
    while counter < size
      yield(self.todos[counter])
      counter += 1
    end
    self
  end

  def select(new_title = "Result of Select Method")
    new_list = TodoList.new(new_title)

    self.todos.each do |el|
      new_list << el if yield(el)
    end
    new_list
  end

  def find_by_title(str)
    match = nil 

    self.todos.each do |item|
      if item.title == str
        match = item
        return match
      end
    end

    match
  end

  def all_done
    self.select("#{self.title} Done") do |item|
      item.done?
    end
  end

  def all_not_done
    self.select("#{self.title} Not Done") do |item|
      !(item.done?)
    end
  end

  def mark_done(str)
    self.todos.each do |item|
      if item.title == str
        item.done!
        return
      end
    end
  end

  def mark_all_done
    self.todos.each do |item|
      item.done!
    end
  end

  def mark_all_undone
    self.todos.each do |item|
      item.undone!
    end
  end

  # rest of class needs implementation

  private

  def is_todo_object?(object)
    object.class == Todo
  end

end


# IMPLEMENTATION
todo1 = Todo.new("Buy milk")
todo2 = Todo.new("Clean room")
todo3 = Todo.new("Go to gym")
list = TodoList.new("Today's Todos")

list << todo1
list << todo2
list << todo3

list.mark_all_done
list.mark_all_undone

puts list.all_done

puts list.all_not_done