from datetime import date
from robot.api.deco import keyword
import time
import glob


@keyword
def get_full_today_date():
    """ Return today's date in Y-m-d format. """
    return date.today().strftime('%Y%m%d')


@keyword
def get_today_date():
    """ Return today's date in Y-m format. """
    return date.today().strftime('%Y%m')


@keyword
def wait_until_file_exists(file_pattern, timeout):
    """ Check if file with given pattern exists. """
    end_time = time.time() + float(timeout)
    while time.time() < end_time:
        if glob.glob(file_pattern):
            return True
        time.sleep(0.1)
    return False
