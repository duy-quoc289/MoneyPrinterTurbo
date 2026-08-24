#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT_DIR"

PILOT_DIR="$ROOT_DIR/storage/tomo_kids_pilot"
mkdir -p "$PILOT_DIR"

make_scene() {
  local output="$1"
  local background="$2"
  local accent_a="$3"
  local accent_b="$4"

  ffmpeg -hide_banner -loglevel error -y \
    -f lavfi -i "color=c=${background}:s=1280x720:d=20:r=30" \
    -vf "drawbox=x=90:y=110:w=220:h=220:color=${accent_a}:t=fill,drawbox=x=970:y=390:w=210:h=210:color=${accent_b}:t=fill,drawbox=x=410:y=175:w=460:h=370:color=0x0F766E@0.96:t=fill,drawbox=x=450:y=215:w=380:h=290:color=0xFDF6E3@1.0:t=fill" \
    -c:v libx264 -pix_fmt yuv420p -movflags +faststart \
    "$output"
}

make_scene "$PILOT_DIR/scene-01.mp4" "0xFFF6D6" "0xFF6B6B" "0xFFD166"
make_scene "$PILOT_DIR/scene-02.mp4" "0xDDF5F2" "0x73D2DE" "0xFF8FA3"
make_scene "$PILOT_DIR/scene-03.mp4" "0xFDE1E7" "0xFFD166" "0x73D2DE"

VIDEO_SCRIPT=$(cat <<'EOF'
Xin chào các bạn nhỏ! Hôm nay Gấu Tò Mò mang theo chiếc kính lúp và một câu hỏi rất vui. Trong ba người bạn: cá, mèo và chim, ai có thể bay trên bầu trời? Hãy nhìn thật kỹ nhé. Cá bơi dưới nước. Mèo chạy trên mặt đất. Còn chim có đôi cánh. Đúng rồi, chim có thể bay! Chim dùng đôi cánh để nâng mình lên không trung. Các bạn giỏi lắm! Hôm nay chúng mình đã biết: cá bơi, mèo chạy và chim bay. Hẹn gặp lại trong câu hỏi Tò Mò tiếp theo!
EOF
)

uv run python cli.py \
  --video-subject "Tò Mò Kids - Ai có thể bay?" \
  --video-script "$VIDEO_SCRIPT" \
  --video-language "vi-VN" \
  --video-source local \
  --video-materials "$PILOT_DIR/scene-01.mp4,$PILOT_DIR/scene-02.mp4,$PILOT_DIR/scene-03.mp4" \
  --video-aspect "16:9" \
  --video-count 1 \
  --video-concat-mode sequential \
  --video-transition-mode fade-in \
  --video-clip-duration 20 \
  --voice-name "vi-VN-HoaiMyNeural-Female" \
  --voice-rate 0.92 \
  --voice-volume 1.05 \
  --bgm-type none \
  --subtitle-enabled \
  --subtitle-position bottom \
  --font-size 48 \
  --text-fore-color "#FFFFFF" \
  --stroke-color "#10233A" \
  --stroke-width 2 \
  --subtitle-background-enabled \
  --subtitle-background-color "#10233A" \
  --rounded-subtitle-background \
  --stop-at video
