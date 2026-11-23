"""Composes App Store marketing screenshots (1320x2868, iPhone 6.9").

Usage: python3 scripts/compose_store_shots.py <raw-shots-dir> <out-dir>
Raw shots are full-resolution simulator captures from store_screenshots.sh.
"""
import sys
from PIL import Image, ImageDraw, ImageFilter, ImageFont

W, H = 1320, 2868
FONTS = 'assets/fonts/'
TOP, BOTTOM = (124, 58, 237), (67, 39, 196)   # brand purple → indigo
ACCENT = (255, 214, 74)                         # yellow highlight words
WHITE = (255, 255, 255)

# (raw file, title parts [(text, highlighted)], subtitle)
SLIDES = [
    ('_attempts_6.png', [('Пробный ОРТ', True), ('\nкак на экзамене', False)],
     '4 раздела, 130 вопросов и таймер'),
    ('_attempts_5_result.png', [('Узнай свой балл', False), ('\nсразу', True)],
     'Шкала ОРТ и разбор по разделам'),
    ('_results.png', [('Следи за ', False), ('ростом', True), ('\nбаллов', False)],
     'Все попытки и результаты в одном месте'),
    ('_tests_3.png', [('Тренируйся', False), ('\nпо разделам', True)],
     'Математика, аналогии, чтение, грамматика'),
    ('_home.png', [('Готовься к ОРТ', False), ('\nкаждый день', True)],
     'Лучший балл и тесты на главном экране'),
    ('_game.png', [('Дуэли ', True), ('1×1', True), ('\nпо формулам', False)],
     'Играй, побеждай и поднимайся в лиге'),
    ('_referrals.png', [('Приглашай ', False), ('друзей', True)],
     'Друг купит тест — тебе тест бесплатно'),
]


def gradient():
    img = Image.new('RGB', (W, H))
    d = ImageDraw.Draw(img)
    for y in range(H):
        t = y / H
        d.line([(0, y), (W, y)], fill=tuple(int(a + (b - a) * t) for a, b in zip(TOP, BOTTOM)))
    # soft decorative circles, like the app header
    glow = Image.new('L', (W, H), 0)
    gd = ImageDraw.Draw(glow)
    gd.ellipse([780, -260, 1620, 580], fill=38)
    gd.ellipse([-380, 1900, 520, 2800], fill=26)
    img.paste(Image.new('RGB', (W, H), WHITE), mask=glow.filter(ImageFilter.GaussianBlur(40)))
    return img


def draw_title(img, parts, subtitle):
    d = ImageDraw.Draw(img)
    title_font = ImageFont.truetype(FONTS + 'stolzl_bold.otf', 104)
    sub_font = ImageFont.truetype(FONTS + 'stolzl_regular.otf', 50)
    # split parts into lines, each line a list of (text, highlighted)
    lines = [[]]
    for text, hi in parts:
        chunks = text.split('\n')
        for i, chunk in enumerate(chunks):
            if i:
                lines.append([])
            if chunk:
                lines[-1].append((chunk, hi))
    y = 190
    for line in lines:
        width = sum(d.textlength(t, font=title_font) for t, _ in line)
        x = (W - width) / 2
        for t, hi in line:
            d.text((x, y), t, font=title_font, fill=ACCENT if hi else WHITE)
            x += d.textlength(t, font=title_font)
        y += 124
    sw = d.textlength(subtitle, font=sub_font)
    d.text(((W - sw) / 2, y + 26), subtitle, font=sub_font, fill=(232, 226, 255))
    return y + 26 + 70


def rounded(im, r):
    mask = Image.new('L', im.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, im.size[0] - 1, im.size[1] - 1], r, fill=255)
    out = Image.new('RGBA', im.size)
    out.paste(im, mask=mask)
    return out


def phone(raw, top, img):
    screen_w = 980
    screen = Image.open(raw).convert('RGB').resize((screen_w, int(screen_w * 2868 / 1320)), Image.LANCZOS)
    bezel = 26
    fw, fh = screen.width + bezel * 2, screen.height + bezel * 2
    x = (W - fw) // 2
    # shadow
    sh = Image.new('L', (W, H), 0)
    ImageDraw.Draw(sh).rounded_rectangle([x + 10, top + 40, x + fw - 10, top + fh + 40], 150, fill=110)
    img.paste(Image.new('RGB', (W, H), (30, 14, 90)), mask=sh.filter(ImageFilter.GaussianBlur(45)))
    frame = Image.new('RGBA', (fw, fh))
    ImageDraw.Draw(frame).rounded_rectangle([0, 0, fw - 1, fh - 1], 150, fill=(18, 18, 22))
    frame.alpha_composite(rounded(screen, 124), (bezel, bezel))
    img.paste(frame, (x, top), frame)


def main(raw_dir, out_dir):
    for i, (raw, parts, sub) in enumerate(SLIDES, 1):
        img = gradient()
        bottom_of_text = draw_title(img, parts, sub)
        phone(f'{raw_dir}/{raw}', max(bottom_of_text + 40, 640), img)
        img.save(f'{out_dir}/{i:02d}.png', optimize=True)
        print('wrote', f'{out_dir}/{i:02d}.png')


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2])
