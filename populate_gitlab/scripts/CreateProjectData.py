NUMBER_TO_CREATE = 100;


from faker import Faker 
fake = Faker()

f = open("../data/project.csv", "w")
f.write("name\n")
for i in range(NUMBER_TO_CREATE):
    f.write(fake.sentence(nb_words=3)+"\n")

f.close()