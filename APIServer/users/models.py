from django.db import models
from django.contrib.auth.models import (
    BaseUserManager, AbstractBaseUser
)

class AppUserManager(BaseUserManager):
    def create_user(self, username, nickname, avatar, From, is_social, password=None):
        if not username:
            raise ValueError('Users must have an username')

        user = self.model(
            username=username,
            nickname=nickname,
            avatar=avatar,
            From=From,
            is_social=is_social
        )

        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, username, nickname, avatar, From, is_social, password):
        """
        Creates and saves a superuser with the given email, date of
        birth and password.
        """
        user = self.create_user(
            username=username,
            password=password,
            nickname=nickname,
            avatar=avatar,
            From=From,
            is_social=is_social
        )
        user.is_admin = True
        user.save(using=self._db)
        return user

class AppUser(AbstractBaseUser):
    username = models.CharField(max_length=255, unique=True)
    nickname = models.CharField(max_length=255)
    avatar = models.CharField(max_length=255, blank=True)

    From = models.CharField(max_length=255)
    is_social = models.BooleanField(default=False)

    is_active = models.BooleanField(default=True)
    is_admin = models.BooleanField(default=False)

    objects = AppUserManager()

    USERNAME_FIELD = 'username'
    REQUIRED_FIELDS = ['nickname','avatar','From','is_social']

    def get_full_name(self):
        # The user is identified by their email address
        return self.username

    def get_short_name(self):
        # The user is identified by their email address
        return self.nickname

    def __str__(self):              # __unicode__ on Python 2
        return self.nickname

    def has_perm(self, perm, obj=None):
        "Does the user have a specific permission?"
        # Simplest possible answer: Yes, always
        return True
        
    def has_module_perms(self, app_label):
        "Does the user have permissions to view the app `app_label`?"
        # Simplest possible answer: Yes, always
        return True

    def __unicode__(self):
        return '%s' % (self.avatar)

    @property
    def is_staff(self):
        "Is the user a member of staff?"
        # Simplest possible answer: All admins are staff
        return self.is_admin