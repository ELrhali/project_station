from rest_framework.routers import DefaultRouter
from django.urls import path, include
from .views import ServiceList, ServiceViewSet

router = DefaultRouter()
router.register(r'', ServiceViewSet, basename='service')

urlpatterns = [
    path('', include(router.urls)),
    path('services', ServiceList.as_view(), name='service-list'),
]
