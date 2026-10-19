import os
import pygame
import scipy.io.wavfile as wavfile

ogg_path = r"C:\Users\pablo\.gemini\antigravity\brain\83b2b2d3-9c1a-4bba-8cfc-c2e9b9381487\.user_uploaded\uploaded_media_1792428804503.ogg"
wav_path = r"C:\Users\pablo\.gemini\antigravity\scratch\practica-nginx-docker\audio\temp_user.wav"

pygame.mixer.init()
sound = pygame.mixer.Sound(ogg_path)
arr = pygame.sndarray.array(sound)
freq, fmt, channels = pygame.mixer.get_init()
print(f"Sampling rate: {freq}, channels: {channels}, duration: {sound.get_length():.2f}s")

wavfile.write(wav_path, freq, arr)
print(f"WAV written to {wav_path}, size: {os.path.getsize(wav_path)} bytes")
