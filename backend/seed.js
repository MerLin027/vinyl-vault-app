const dotenv = require("dotenv");
const mongoose = require("mongoose");

const Product = require("./models/Product");

dotenv.config();

const makeImageUrl = (title) =>
  `https://placehold.co/400x400?text=${title.replace(/\s+/g, "+")}`;

const products = [
  {
    title: "Abbey Road",
    artist: "The Beatles",
    price: 2299,
    genre: "Rock",
    decade: "1960s",
    condition: "Near Mint",
    rating: 4.9,
    images: [makeImageUrl("Abbey Road")],
    description: "A studio masterpiece blending melodic pop with daring arrangements. This pressing captures the warmth and detail of the original sessions.",
  },
  {
    title: "Dark Side of the Moon",
    artist: "Pink Floyd",
    price: 2399,
    genre: "Rock",
    decade: "1970s",
    condition: "Very Good",
    rating: 4.9,
    images: [makeImageUrl("Dark Side of the Moon")],
    description: "An immersive concept album with cinematic soundscapes and iconic transitions. Essential for progressive rock collectors.",
  },
  {
    title: "Back in Black",
    artist: "AC/DC",
    price: 1899,
    genre: "Rock",
    decade: "1980s",
    condition: "Good",
    rating: 4.6,
    images: [makeImageUrl("Back in Black")],
    description: "Explosive riffs and relentless groove from start to finish. A hard rock landmark that still feels raw and immediate.",
  },
  {
    title: "Nevermind",
    artist: "Nirvana",
    price: 1999,
    genre: "Rock",
    decade: "1990s",
    condition: "Near Mint",
    rating: 4.7,
    images: [makeImageUrl("Nevermind")],
    description: "The record that pushed alternative rock into the mainstream. Loud, emotional, and unforgettable.",
  },
  {
    title: "Kind of Blue",
    artist: "Miles Davis",
    price: 2199,
    genre: "Jazz",
    decade: "1960s",
    condition: "Mint",
    rating: 5.0,
    images: [makeImageUrl("Kind of Blue")],
    description: "A timeless modal jazz session with elegant interplay and nuanced performances. Frequently cited as one of the greatest jazz albums ever.",
  },
  {
    title: "A Love Supreme",
    artist: "John Coltrane",
    price: 2099,
    genre: "Jazz",
    decade: "1960s",
    condition: "Very Good",
    rating: 4.8,
    images: [makeImageUrl("A Love Supreme")],
    description: "A deeply spiritual suite balancing intensity and grace. Coltrane's quartet is in extraordinary form throughout.",
  },
  {
    title: "Head Hunters",
    artist: "Herbie Hancock",
    price: 1799,
    genre: "Jazz",
    decade: "1970s",
    condition: "Good",
    rating: 4.5,
    images: [makeImageUrl("Head Hunters")],
    description: "Funk-forward jazz fusion powered by thick grooves and synth textures. A perfect bridge between jazz and modern rhythm music.",
  },
  {
    title: "Illmatic",
    artist: "Nas",
    price: 1999,
    genre: "Hip-Hop",
    decade: "1990s",
    condition: "Near Mint",
    rating: 4.9,
    images: [makeImageUrl("Illmatic")],
    description: "Sharp lyricism over atmospheric East Coast production. A concise classic that set a new benchmark for rap albums.",
  },
  {
    title: "The Marshall Mathers LP",
    artist: "Eminem",
    price: 1899,
    genre: "Hip-Hop",
    decade: "2000s",
    condition: "Very Good",
    rating: 4.6,
    images: [makeImageUrl("The Marshall Mathers LP")],
    description: "A fast, provocative, and technically impressive record. Its storytelling and flow shifts remain standout moments in hip-hop.",
  },
  {
    title: "To Pimp a Butterfly",
    artist: "Kendrick Lamar",
    price: 2499,
    genre: "Hip-Hop",
    decade: "2000s",
    condition: "Mint",
    rating: 5.0,
    images: [makeImageUrl("To Pimp a Butterfly")],
    description: "A bold fusion of rap, jazz, and funk with dense social commentary. Sonically rich and conceptually ambitious.",
  },
  {
    title: "Discovery",
    artist: "Daft Punk",
    price: 1799,
    genre: "Electronic",
    decade: "2000s",
    condition: "Near Mint",
    rating: 4.8,
    images: [makeImageUrl("Discovery")],
    description: "House, disco, and pop influences combined into a celebratory electronic set. The melodies are bright and instantly memorable.",
  },
  {
    title: "Music Has the Right to Children",
    artist: "Boards of Canada",
    price: 1599,
    genre: "Electronic",
    decade: "1990s",
    condition: "Good",
    rating: 4.4,
    images: [makeImageUrl("Music Has the Right to Children")],
    description: "Dreamlike beats and nostalgic textures shape this influential ambient electronic release. Perfect for late-night listening.",
  },
  {
    title: "The Four Seasons",
    artist: "Antonio Vivaldi",
    price: 1399,
    genre: "Classical",
    decade: "1960s",
    condition: "Very Good",
    rating: 4.3,
    images: [makeImageUrl("The Four Seasons")],
    description: "A vibrant recording of Vivaldi's beloved concertos with crisp dynamics. The performance balances precision and emotion.",
  },
  {
    title: "Symphony No. 9",
    artist: "Ludwig van Beethoven",
    price: 1499,
    genre: "Classical",
    decade: "1970s",
    condition: "Near Mint",
    rating: 4.7,
    images: [makeImageUrl("Symphony No. 9")],
    description: "A dramatic and uplifting interpretation of Beethoven's monumental symphony. The final movement sounds expansive and powerful.",
  },
  {
    title: "Thriller",
    artist: "Michael Jackson",
    price: 2399,
    genre: "Pop",
    decade: "1980s",
    condition: "Near Mint",
    rating: 4.9,
    images: [makeImageUrl("Thriller")],
    description: "A genre-defining pop album packed with iconic hooks and polished production. Every track contributes to its enduring legacy.",
  },
];

const seedProducts = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI);

    await Product.deleteMany({});

    const insertedProducts = await Product.insertMany(products);

    console.log(`Seeded ${insertedProducts.length} products successfully`);
  } catch (error) {
    console.error("Seeding failed:", error.message);
    process.exitCode = 1;
  } finally {
    await mongoose.disconnect();
  }
};

seedProducts();
