from rest_framework.routers import DefaultRouter
from django.urls import path, include
from .views import GazoleList, GazoleViewSet

router = DefaultRouter()
router.register(r'', GazoleViewSet, basename='gazoles')
# router.register(r'gazole-status', GazoleStatusViewSet, basename='gazole_status')

urlpatterns = [
    path('', include(router.urls)),
    path('gazoles', GazoleList.as_view(), name='gazole-list'),
]
