from robot.api.deco import keyword
from tinyWinToast.tinyWinToast import *
from datetime import datetime
import os


main_path = os.path.join(os.getenv('APPDATA'), 'EKW-checker')
rcc_path = os.path.join(main_path, 'rcc')
output_path = os.path.join(rcc_path, 'output')
icon_path = os.path.join(main_path, 'ekw.png')


def get_new_notification(duration):
    config = Config()
    config.APP_ID = "EKW checker"
    config.DURATION = duration

    notification = Toast(config)
    notification.setIcon(icon_path, crop=CROP_CIRCLE)
    notification.setTitle("EKW check", maxLines=1)
    return notification


def add_current_time_to_notification(notification):
    current_time = datetime.now().strftime("%H:%M")
    notification.addText(current_time, maxLines=1)


@keyword
def show_status_notification(success=True, surname_found=False, bankName_found=False):
    '''
    param: success (bool)
    param: surname_found (bool)
    param: bankName_found (bool)
    Show the Windows notification with task status.
    '''
    
    if not success:
        notification = get_new_notification(DURATION_LONG)
        notification.setMessage('Task failed.', maxLines=1)
        notification.addButton(Button(content='Open log folder', activationType=ACTION_TYPE_PROTOCOL, arguments=output_path, pendingUpdate=False))
    else:
        notification = get_new_notification(DURATION_SHORT)
        notification.setMessage('Task completed successfully.', maxLines=1)
        surname_message = 'New owner entry has been found in KW.' if surname_found else 'No new owner entry yet in KW.'
        bankName_found = 'New mortgage entry has been found in KW.' if bankName_found else 'No new mortgage entry yet in KW.'
        notification.setMessage(surname_message, maxLines=1)
        notification.setMessage(bankName_found, maxLines=1)
            
    add_current_time_to_notification(notification)
    notification.show()
    
    
@keyword
def show_start_notification():
    '''
    Show the Windows notification when the task starts.
    '''
    notification = get_new_notification(DURATION_SHORT)
    notification.setMessage('Task has started.', maxLines=1)
    add_current_time_to_notification(notification)
    notification.show()