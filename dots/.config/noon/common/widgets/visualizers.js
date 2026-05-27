.pragma library

function drawFilled(root, ctx, w, h, n, maxVal) {
    ctx.beginPath();
    ctx.moveTo(0, h);
    for (var i = 0; i < n; ++i) {
        var x = i * w / (n - 1);
        var y = h - (root.points[i] / maxVal) * h;
        ctx.lineTo(x, y);
    }
    ctx.lineTo(w, h);
    ctx.closePath();
    ctx.fillStyle = Qt.rgba(root.color.r, root.color.g, root.color.b, 0.15);
    ctx.fill();
}

function drawBars(root, ctx, w, h, n, maxVal) {
    var barWidth = (w - (n - 1) * root.thickBarSpacing) / n;
    var cornerRadius = Math.min(root.thickBarCornerRadius, barWidth / 2);

    for (var i = 0; i < n; ++i) {
        var x = i * (barWidth + root.thickBarSpacing);
        var barHeight = Math.max(cornerRadius * 2, (root.points[i] / maxVal) * h);
        var y = h - barHeight;

        ctx.beginPath();
        ctx.moveTo(x, h);
        ctx.lineTo(x, y + cornerRadius);
        ctx.quadraticCurveTo(x, y, x + cornerRadius, y);
        ctx.lineTo(x + barWidth - cornerRadius, y);
        ctx.quadraticCurveTo(x + barWidth, y, x + barWidth, y + cornerRadius);
        ctx.lineTo(x + barWidth, h);
        ctx.closePath();

        var gradient = ctx.createLinearGradient(x, y, x + barWidth, y);
        gradient.addColorStop(0, Qt.rgba(root.color.r, root.color.g, root.color.b, 0.9));
        gradient.addColorStop(0.5, Qt.rgba(root.color.r, root.color.g, root.color.b, 1));
        gradient.addColorStop(1, Qt.rgba(root.color.r, root.color.g, root.color.b, 0.9));
        ctx.fillStyle = gradient;
        ctx.fill();
    }
}

function drawWaveform(root, ctx, w, h, n, maxVal) {
    var centerY = h / 2;

    ctx.beginPath();
    ctx.moveTo(0, centerY);
    for (var i = 0; i < n; ++i) {
        var x = i * w / (n - 1);
        var amplitude = (root.points[i] / maxVal) * (centerY * 0.8);
        ctx.lineTo(x, centerY - amplitude);
    }
    ctx.lineTo(w, centerY);
    ctx.closePath();
    ctx.fillStyle = Qt.rgba(root.color.r, root.color.g, root.color.b, 0.6);
    ctx.fill();

    ctx.beginPath();
    ctx.moveTo(0, centerY);
    for (var i = 0; i < n; ++i) {
        var x = i * w / (n - 1);
        var amplitude = (root.points[i] / maxVal) * (centerY * 0.8);
        ctx.lineTo(x, centerY + amplitude);
    }
    ctx.lineTo(w, centerY);
    ctx.closePath();
    ctx.fillStyle = Qt.rgba(root.color.r, root.color.g, root.color.b, 0.2);
    ctx.fill();
}

function drawCapsuleWaves(root, ctx, w, h, n, maxVal) {
    var barWidth = (w - (n - 1) * root.thickBarSpacing) / n;
    var radius = barWidth / 2;
    var centerY = h / 2;

    ctx.fillStyle = root.color;

    for (var i = 0; i < n; ++i) {
        var x = i * (barWidth + root.thickBarSpacing);
        var totalHeight = Math.max(barWidth, (root.points[i] / maxVal) * h * 0.85);
        var topY = centerY - (totalHeight / 2);
        var bottomY = centerY + (totalHeight / 2);

        ctx.beginPath();
        ctx.arc(x + radius, topY + radius, radius, Math.PI, 0, false);
        ctx.lineTo(x + barWidth, bottomY - radius);
        ctx.arc(x + radius, bottomY - radius, radius, 0, Math.PI, false);
        ctx.lineTo(x, topY + radius);
        ctx.closePath();
        ctx.fill();
    }
}

function drawLineGlow(root, ctx, w, h, n, maxVal) {
    ctx.shadowBlur = 15;
    ctx.shadowColor = root.color;
    ctx.strokeStyle = root.color;
    ctx.lineWidth = 3;
    ctx.lineCap = "round";
    ctx.lineJoin = "round";

    ctx.beginPath();
    if (n > 1) {
        var x0 = 0;
        var y0 = h - (root.points[0] / maxVal) * h * 0.9 - 5;
        ctx.moveTo(x0, y0);

        for (var i = 0; i < n - 1; ++i) {
            var x1 = i * w / (n - 1);
            var y1 = h - (root.points[i] / maxVal) * h * 0.9 - 5;
            var x2 = (i + 1) * w / (n - 1);
            var y2 = h - (root.points[i + 1] / maxVal) * h * 0.9 - 5;

            var xc = (x1 + x2) / 2;
            var yc = (y1 + y2) / 2;
            ctx.quadraticCurveTo(x1, y1, xc, yc);
        }
        ctx.lineTo(w, h - (root.points[n - 1] / maxVal) * h * 0.9 - 5);
    }
    ctx.stroke();

    ctx.shadowBlur = 0;
}
