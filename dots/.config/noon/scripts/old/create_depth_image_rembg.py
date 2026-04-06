#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import argparse
import sys
from pathlib import Path

import onnxruntime as ort
from rembg import new_session, remove


def process_image_rembg(
    input_path_str: str,
    output_path_str: str,
    model_name: str = "u2net",
    alpha_matting: bool = False,
    foreground_threshold: int = 240,
    background_threshold: int = 10,
    erode_size: int = 15,
):
    """Remove image background using rembg (ONNX Runtime compatible)"""
    input_path = Path(input_path_str)
    output_path = Path(output_path_str).with_suffix(".png")

    if not input_path.is_file():
        sys.exit(1)

    output_path.parent.mkdir(parents=True, exist_ok=True)

    if output_path.exists():
        return

    try:
        providers = (
            ["CUDAExecutionProvider", "CPUExecutionProvider"]
            if "CUDAExecutionProvider" in ort.get_available_providers()
            else ["CPUExecutionProvider"]
        )

        session = new_session(model_name, providers=providers)

        with open(input_path, "rb") as i:
            input_data = i.read()

        output_data = remove(
            input_data,
            session=session,
            alpha_matting=alpha_matting,
            alpha_matting_foreground_threshold=foreground_threshold,
            alpha_matting_background_threshold=background_threshold,
            alpha_matting_erode_size=erode_size,
        )

        with open(output_path, "wb") as o:
            o.write(output_data)

    except Exception:
        sys.exit(1)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Remove background from image using rembg"
    )
    parser.add_argument("input_path", help="Input image file")
    parser.add_argument("output_path", help="Output PNG file path")
    parser.add_argument(
        "-m", "--model", choices=["u2net", "isnet-general-use"], default="u2net"
    )
    parser.add_argument(
        "-a", "--alpha-matting", action="store_true", help="Enable alpha matting"
    )
    parser.add_argument("-ft", "--foreground-threshold", type=int, default=240)
    parser.add_argument("-bt", "--background-threshold", type=int, default=10)
    parser.add_argument("-e", "--erode-size", type=int, default=15)

    args = parser.parse_args()

    process_image_rembg(
        args.input_path,
        args.output_path,
        args.model,
        args.alpha_matting,
        args.foreground_threshold,
        args.background_threshold,
        args.erode_size,
    )
