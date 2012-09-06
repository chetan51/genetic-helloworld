class Chromosome
	@target: "Hello, world!"

	constructor: ->
		# Compose random string of target length
		@code = String.fromCharCode((Math.floor(Math.random() * 94) + 32 for i in [1..Chromosome.target.length])...)

	mutate: =>
		# Choose a random index of the code to mutate
		index = Math.floor(Math.random() * Chromosome.target.length)
		# Choose a random amount to mutate the code by
		while not shift_by
			shift_by = Math.floor(Math.random() * 11) - 5 # between -5 and 5
		# Mutate the character
		mutated = String.fromCharCode(@code[index].charCodeAt(0) + shift_by)

		# Create a new mutated chromosome	
		chromosome = new Chromosome
		chromosome.code = @code.substr(0, index) + mutated + @code.substr(index + 1)
		return chromosome

	mate: (chromosome) ->
		# Choose an index in the middle of the chromosomes to pivot around
		index = Chromosome.target.length / 2

		# Create a new child
		child = new Chromosome
		child.code = @code.substr(0, index) + chromosome.code.substr(index)
		return child

	cost: ->
		total = 0
		for i in [0...@code.length]
			# Add absolute value of each character's ASCII difference from the target to the total cost
			total += Math.abs(@code[i].charCodeAt(0) - Chromosome.target[i].charCodeAt(0))
		total

class Population
	@size: 50

	constructor: ->
		@chromosomes = (new Chromosome for i in [1..Population.size])

	sort: ->
		@chromosomes.sort (a, b) ->
			if a.cost() > b.cost() then 1 else -1

	kill: (n) ->
		@chromosomes = @chromosomes[0...(@chromosomes.length - n)]

	mate: (n) ->
		# Put a cap on n
		n = Math.min(n, @chromosomes.length - 1)
		# Mate each chromosome with the next one, from top to bottom
		children = []
		for i in [0...n]
			c1 = @chromosomes[i]
			c2 = @chromosomes[i + 1]
			children.push(c1.mate(c2))
		@chromosomes.push(children...)

	mutate: (n) ->
		# Put a cap on n
		n = Math.min(n, @chromosomes.length)
		# Randomly mutate n chromosomes
		for i in [0...n]
			@chromosomes[i] = @chromosomes[i].mutate()

	score: ->
		@chromosomes[0].cost()

	evolve: ->
		@sort()
		@kill(20)
		@mate(20)
		@mutate(25)


## Main
## ####
display = (n) ->
	console.log "Generation " + i + ":\t\t" + p.chromosomes[0].code
p = new Population
i = 0
display(i)
while p.score() != 0
	p.evolve()
	i += 1
	display(i)


## Testing
## #######

## Chromosomes
## -----------

## Mutation
# console.log(c.code)
# for i in [1..10]
# 	c = c.mutate()
# 	console.log(c.code)

## Mating
# c1 = new Chromosome
# c2 = new Chromosome
# console.log(c1.code)
# console.log(c2.code)
# console.log(c1.mate(c2).code)

## Cost calculation
# c = new Chromosome
# c.code = "Hello, world!"
# console.log(c.cost())
# c.code = "Hellp, world!"
# console.log(c.cost())
# c.code = "Hellq, world!"
# console.log(c.cost())
# c = new Chromosome
# console.log(c.code)
# console.log(c.cost())

## Populations
## -----------

## Sorting
# p = new Population
# console.log p.chromosomes
# console.log (c.cost() for c in p.chromosomes)
# p.sort()
# console.log (c.cost() for c in p.chromosomes)

## Killing
# p = new Population
# console.log p.chromosomes.length
# p.kill(3)
# console.log p.chromosomes.length

## Mating
# p = new Population
# console.log(p.chromosomes)
# p.mate(2)
# console.log(p.chromosomes)
# console.log("\n")
# p = new Population
# console.log(p.chromosomes)
# p.mate(4)
# console.log(p.chromosomes)
# console.log("\n")
# p = new Population
# console.log(p.chromosomes)
# p.mate(5)
# console.log(p.chromosomes)

## Mutating
# p = new Population
# console.log(p.chromosomes)
# p.mutate(2)
# console.log(p.chromosomes)
# console.log("\n")
# p = new Population
# console.log(p.chromosomes)
# p.mutate(6)
# console.log(p.chromosomes)

## Evolving
# p = new Population
# console.log p.chromosomes.length
# p.evolve()
# console.log p.chromosomes.length
