import asyncio
from libqtile.hook import qtile_hooks
from libqtile.log_utils import logger

async def _restack_intellij(client):
    if "jetbrains-idea" in client.get_wm_class() and client.has_focus:
        await asyncio.sleep(0.5)
        client.bring_to_front()

def init():
    logger.info("Initializing restack-intellij hook")
    qtile_hooks.subscribe.client_managed(_restack_intellij)