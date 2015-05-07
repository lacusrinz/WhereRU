from django.conf.urls import patterns, include, url


from django.contrib import admin

from rest_framework.routers import DefaultRouter
from rest_framework_nested import routers

from friends import views as friendsView
from events import views as eventsView

admin.autodiscover()

router = routers.SimpleRouter()
router.register(r'friends',friendsView.UsersViewSet)
router.register(r'events',eventsView.EventViewSet)
router.register(r'participants',eventsView.ParticipantViewSet)

# event_router = routers.NestedSimpleRouter(router,r'events',lookup='event')
# event_router.register(r'participants',eventsView.ParticipantViewSet)

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'django_user_manager_server.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),

    url(r'^admin/', include(admin.site.urls)),
    url(r'^auth/', include('djoser.urls')),
    url(r'^', include(router.urls)),
    # url(r'^', include(event_router.urls)),
    # url(r'^oauth2/', include('provider.oauth2.urls', namespace='oauth2')),
)
