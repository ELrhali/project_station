from django.contrib.auth.models import User  # Import the User model
from django.contrib.auth.hashers import make_password  # Import make_password function
from rest_framework.serializers import ModelSerializer

from .models import Utilisateur

class UtilisateurSerializer(ModelSerializer):
    class Meta:
        model = Utilisateur
        fields = '__all__'



class UserSerializer(ModelSerializer):
    class Meta:
        model = User
        fields = '__all__'
        extra_kwargs = {
            'password': {'write_only': True, 'required': True}
        }

    def create(self, validated_data):
        # Here, instead of popping 'password' and setting it directly,
        # use Django's `make_password` function for hashing.
        password = validated_data.pop('password', None)
        user = super().create(validated_data)  # Let ModelSerializer handle object creation
        if password:
            user.password = make_password(password)
            user.save()
        return user
