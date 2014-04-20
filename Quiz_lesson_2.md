Quiz: Lesson 2

1. 	@a = 2
	# => @a is an instance variable, and is a Fixnum object with value 2
	
	user = User.new 
	# => user is an object and an instance of the User class.

	user.name
	# => user.name is a getter method of the object user.

	user.name = "Joe"
	# => As above, it is a method but more specifically a setter method with a string
		 value equal to 'Joe'

2. How does a class mixin a module?
   # => We 'include' the module within the Class to inherit its methods.

3. What's the difference between class variables and instance variables?
   # There is only one version of a class variable and it is shared between all
   	 instances of the class. Class variables are prefixed with '@@' where as instance variables are prefixed with '@'. An instance variable is unique to each object.

4. What does attr_accessor do? 
   It defines getter and setter methods automatically, reducing the amount of code that is required.

5. Dog.some_method is a class method

6. In Ruby, what's the difference between subclassing and mixing in modules?
   Subclassing is used in hierarchical structures and were relationships can be described as 'is-a'. Modules are used in 'has-a' relationships.

7. Given that I can instantiate a user like this: User.new('Bob'), what would the initialize 	method look like for the User class?
  Class User
    attr_accessor :name

	def initialize(name)
	  @name = name
	end
  end

8. Can you call instance methods of the same class from other instance methods?
   Yes, you have to prefix 'self' when calling the method.

9. When you get stuck, what's the process you use to try to trap the error?
   Using pry: "require 'pry'"" and then use "binding.pry" in the suspected area, eliminating sections as you move through the code.