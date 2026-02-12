import logging

from allauth.account.adapter import DefaultAccountAdapter


logger = logging.getLogger(__name__)


class SafeAccountAdapter(DefaultAccountAdapter):
    def send_mail(self, template_prefix, email, context, *args, **kwargs):
        try:
            super().send_mail(template_prefix, email, context, *args, **kwargs)
        except Exception:
            # Keep signup/login flow working even if SMTP provider fails.
            logger.exception("Failed to send allauth email to %s", email)
