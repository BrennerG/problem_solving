import time


def current_milli_time():
    """
    Returns the current time in milliseconds.

    :return: current time in milliseconds
    """
    return int(round(time.time() * 1000))
