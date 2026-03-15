const puppeteer = require('puppeteer');
const path = require('path');

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  await page.setViewport({ width: 1200, height: 300, deviceScaleFactor: 2 });
  await page.goto('file://' + path.resolve(__dirname, 'banner.html'), { waitUntil: 'networkidle0' });
  await page.evaluateHandle('document.fonts.ready');
  await new Promise(r => setTimeout(r, 2000));
  await page.screenshot({
    path: path.resolve(__dirname, '../assets/images/banner.png'),
    clip: { x: 0, y: 0, width: 1200, height: 300 }
  });
  await browser.close();
  console.log('Banner exported to assets/images/banner.png');
})();
