import logging
import azure.functions as func

def main(event: func.EventHubEvent):
    logging.info(f'Processing message: {event.get_body().decode()}')
    # Logic to process the data and send to ADX or Blob Storage
