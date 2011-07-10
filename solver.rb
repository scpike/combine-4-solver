#!/usr/bin/ruby

class Solver
  attr_accessor :inputs, :operators, :equations,:answer
  def initialize(inputs)
    @inputs= inputs
    @operators = [:-,:*,:/,:+]
    @equations  = []
    @answer = nil
  end
  
  def generate_equations
    potential_input_orders = inputs.permutation.collect.to_a.uniq
    # All the ways we can order our operators into the input-1 slots
    potential_operator_orders = (@operators * (@inputs.length-1)).combination(@inputs.length-1).collect.to_a.uniq

    i=0
    for input_set in potential_input_orders
      for operator_order in potential_operator_orders
        potential_input_sets = split_set(input_set)
        for final_input_set in potential_input_sets
          equation = Equation.new(final_input_set, operator_order.clone)
          self.equations = self.equations + [equation]
          i = i + 1          
          break
        end
      end
    end
  end

  def find_answer(target=24)
    for equation in equations
      if equation.result == target
        self.answer = equation
        break
      end
    end
    if answer 
      puts "#{inputs.inspect} - #{answer.print} = #{answer.result}"
    else
      puts "#{inputs.inspect} - No Answer Found"
    end
  end
  # Take a set and generate all the distinct sets of subsets of <set> such that the subsets collectively contain exactly all elements of <set> 
  def split_set(set)
    if set.length == 1
      set
    else
      sets = []
      left_set_size = 1
      while(left_set_size < set.length )
        left_set = set[0,left_set_size]
        right_set = set[left_set_size,set.length]
        left_sets = split_set(left_set)
        right_sets = split_set(right_set)
        for left in left_sets
          for right in right_sets
            sets = sets + [[left,right]]
          end
        end
        left_set_size = left_set_size + 1 
        end
      sets
      end
   
    end
  end
  
class Equation
  attr_accessor :root, :answer
  # Represent an equation as a binary tree of operators / inputs
  def initialize(inputs,operators)
    self.root = Node.new
    self.root.build(inputs,operators)
    self.answer = nil
  end
  
  def print
    root.print_inorder
  end

  def result
    # memorize
    if self.answer == nil
      self.answer = root.eval_inorder
    else
      self.answer
    end
  end
end

class Node
  attr_accessor :left_child,:right_child, :value

  def initialize(value=nil)
    @value = value
  end
  
  def print_inorder    
    if is_leaf
      value.to_s
    else
      "(" + left_child.print_inorder + ' ' + value.to_s + ' ' + right_child.print_inorder + ")"
    end
  end

  def replicate
    new_node = Node.new(value)
    new_node.left_child = left_child.replicate if left_child
    new_node.right_child = right_child.replicate if right_child
    new_node
  end

  def is_leaf
    left_child == nil and right_child == nil
  end

  def eval_inorder
    if !is_leaf
      left_child.eval_inorder.to_f.send(value, right_child.eval_inorder.to_f)
    else
      value
    end
    
  end
  
  def build(inputs, operators)
    if !inputs.is_a?(Array) 
      self.value = inputs
    elsif inputs.length== 1
      self.value = inputs.first
    else
      self.value = operators.pop
      self.left_child=Node.new
      self.left_child.build(inputs[0], operators)
      self.right_child= Node.new
      self.right_child.build(inputs[1], operators)
    end
  end
  
end
inputs = ARGV[0]

File.open(inputs).each do |line|
  solver = Solver.new(eval(line))
  solver.generate_equations
  solver.find_answer(24)
end
