# src/utilities/image_io.py
# Dependencies for image input/output operations
import cv2


def read_image(file_path: str):
    """
    Reads an image from the specified file path.
    Args:
        file_path (str): The path to the image file.
    Returns:
        image: The image read from the file.
    """
    image = cv2.imread(file_path)
    if image is None:
        raise FileNotFoundError(f"Image not found at path: {file_path}")
    return image


def save_image(file_path: str, image) -> None:
    """
    Saves an image to the specified file path.
    Args:
        file_path (str): The path where the image will be saved.
        image: The image to be saved.
    """
    cv2.imwrite(file_path, image)
