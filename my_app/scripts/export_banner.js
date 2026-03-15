const puppeteer = require('puppeteer');
const path = require('path');

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  await page.setViewport({ width: 800, height: 200, deviceScaleFactor: 2 });
  await page.goto('file://' + path.resolve(__dirname, 'banner.html'));
  await new Promise(r => setTimeout(r, 1500)); // waitForTimeout is deprecated in newer Puppeteer, using standard promise
  await page.screenshot({
    path: path.resolve(__dirname, '../assets/images/banner.png'),
    clip: { x: 0, y: 0, width: 800, height: 200 }
  });
  await browser.close();
  console.log('Banner exported to assets/images/banner.png');
})();
