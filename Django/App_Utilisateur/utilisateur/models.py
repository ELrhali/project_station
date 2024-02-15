from django.db import models
from django.contrib.auth.models import User
from django.contrib.auth.hashers import make_password

import enum

class RoleType(enum.Enum):
    ADMIN = "Admin"
    USER = "User"
    
    def __str__(self):
        return self.value


class UtilisateurManager(models.Manager):
    def create_user(self, city, phone, role, user):
        # Here, user is expected to be a User instance. 
        # The method then creates a Utilisateur instance associated with this User.
        utilisateur = self.model(city=city, phone=phone, role=role, user=user)
        # Save the Utilisateur instance to the database.
        utilisateur.save(using=self._db)
        return utilisateur


class Utilisateur(models.Model):
    city = models.CharField(max_length=100)
    phone = models.CharField(max_length=20)
    role = models.CharField(
        max_length=255,
        choices=[(tag.name, tag.value) for tag in RoleType],
        default=RoleType.USER
    )
    user = models.ForeignKey(User, on_delete=models.CASCADE, null=True)
    
    # Set the custom manager
    objects = UtilisateurManager()
    
    def __str__(self):
        return self.user.email  # Assuming 'user' is not null

# Make sure to replace `self.email` with `self.user.email` in the `__str__` method,
# as `Utilisateur` does not directly have an `email` field; it's part of the related `User` instance.
