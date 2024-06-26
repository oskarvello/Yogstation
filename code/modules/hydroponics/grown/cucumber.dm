/obj/item/seeds/cucumber
	name = "pack of cucumber seeds"
	desc = "These seeds grow into cucumber plants."
	icon_state = "seed-cucumber"
	species = "cucumber"
	plantname = "Cucumber Plant"
	product = /obj/item/reagent_containers/food/snacks/grown/cucumber
	maturation = 10
	production = 1
	yield = 5
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "cucumber-grow"
	icon_dead = "cucumber-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/reagent_containers/food/snacks/grown/cucumber
	seed = /obj/item/seeds/cucumber
	name = "cucumber"
	desc = "Oblong and green, the standard of salads."
	icon_state = "cucumber"
	foodtype = VEGETABLES
	juice_results = list(/datum/reagent/consumable/cucumberjuice = 0)
	tastes = list("cucumber" = 1)