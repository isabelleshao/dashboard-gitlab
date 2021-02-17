
NUMBER_TO_CREATE = 100;


from faker import Faker 
fake = Faker()

f = open("../data/user.csv", "w")
f.write("name,email\n")
for i in range(NUMBER_TO_CREATE):
    f.write(fake.name()+","+fake.email()+"\n")

f.close()