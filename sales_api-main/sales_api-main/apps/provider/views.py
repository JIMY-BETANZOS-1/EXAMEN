from rest_framework import viewsets 
from rest_framework.permissions import AllowAny 
from apps.provider.models import Provider 
from apps.provider.serializers import ProviderSerializer 
class ProviderViewSet(viewsets.ModelViewSet): 
    queryset = Provider.objects.all() 
    serializer_class = ProviderSerializer 
    permission_classes = [AllowAny] 
