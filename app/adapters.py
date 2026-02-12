import logging

from allauth.account.adapter import DefaultAccountAdapter
from django.conf import settings


logger = logging.getLogger(__name__)


class SafeAccountAdapter(DefaultAccountAdapter):
    def send_mail(self, template_prefix, email, context, *args, **kwargs):
        try:
            super().send_mail(template_prefix, email, context, *args, **kwargs)
        except Exception:
            logger.exception("Failed to send allauth email to %s", email)
            if not getattr(settings, "EMAIL_FAIL_SILENTLY", False):
                raise
