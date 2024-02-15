from django.http import JsonResponse
from rest_framework import permissions
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated,AllowAny
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from rest_framework_simplejwt.views import TokenObtainPairView
from django.contrib.auth.models import User 
from rest_framework_simplejwt.tokens import UntypedToken
from rest_framework_simplejwt.exceptions import InvalidToken, TokenError
from rest_framework_simplejwt.settings import api_settings
from .serializers import UserSerializer, UtilisateurSerializer
from .models import Utilisateur


@api_view(['POST'])
@permission_classes([AllowAny])
def registerUser(request):
    """
    Register a new user and create an associated Utilisateur instance.
    """
    data = request.data
    # Check if a user with the provided username already exists
    if User.objects.filter(username=data['username']).exists():
        # Return an error response if the username is already taken
        return Response({'detail': 'A user with this username already exists.'}, status=400)
    
    try:
        # Proceed with creating a new User and Utilisateur instance since the username is unique
        user = User.objects.create_user(
            username=data['username'],
            email=data['email'],
            password=data['password']
        )
        
        # Assuming 'role' is passed as the role's name ('ADMIN' or 'USER')
        role = data.get('role', 'USER')  # Default to 'USER' if not provided

        utilisateur = Utilisateur.objects.create_user(
            city=data['city'],
            phone=data['phone'],
            role=role,
            user=user
        )
        
        user_serializer = UserSerializer(user, many=False)
        utilisateur_serializer = UtilisateurSerializer(utilisateur, many=False)

        # Combine user and utilisateur data into a single response
        response_data = {
            'user': {
                "id": user_serializer.data['id'],
                "city": utilisateur_serializer.data['city'],
                "phone": utilisateur_serializer.data['phone'],
                "role": utilisateur_serializer.data['role'],
                "username": user_serializer.data['username'],
                "first_name": user_serializer.data['first_name'],
                "last_name": user_serializer.data['last_name'],
                "email": user_serializer.data['email'],
            }
        }
        
        return Response(response_data)
    except Exception as e:
        message = {'detail': str(e)}
        return Response(message, status=400)
#

class MyTokenObtainPairSerializer(TokenObtainPairSerializer):
    @classmethod
    def get_token(cls, user):
        token = super().get_token(user)

        # Add custom claims
        
        token['username'] = user.username
        # ...

        return token


class MyTokenObtainPairView(TokenObtainPairView):
    serializer_class = MyTokenObtainPairSerializer


@api_view(['GET'])
def getRoutes(request):
    routes = [
        '/api/token',
        '/api/token/refresh',
    ]

    return Response(routes)



@api_view(['POST'])
@permission_classes([AllowAny])
def verify_token(request):
    """
    Custom endpoint to verify JWT tokens.
    """
    
    token = request.data.get('token')

    if not token:
        return JsonResponse({'detail': 'No token provided'}, status=400)

    try:
        UntypedToken(token)
        return JsonResponse({'detail': 'Token is valid'}, status=200)
    except (InvalidToken, TokenError) as e:
        return JsonResponse({'detail': str(e)}, status=401)

