const mongoose = require("mongoose");

const productSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: true,
      trim: true,
    },
    artist: {
      type: String,
      required: true,
      trim: true,
    },
    price: {
      type: Number,
      required: true,
    },
    genre: {
      type: String,
      required: true,
      enum: [
        "Rock",
        "Jazz",
        "Hip-Hop",
        "Electronic",
        "Classical",
        "Pop",
        "Alternative",
        "Indie",
        "Alternative Rock",
        "Indie Rock",
        "Pop Rock",
        "Indie Pop",
        "Synth-pop",
        "Art Pop",
        "Art Rock",
        "Classic Rock",
        "Psychedelic Rock",
        "Psychedelic Pop",
        "Experimental Rock",
        "Ambient Pop",
        "Dream Pop",
        "Slowcore",
        "Alternative R&B",
        "R&B",
        "Lo-fi",
        "Dark Pop",
        "Soft Rock",
        "Folk Pop",
        "Acoustic Pop",
        "EDM",
      ],
    },
    decade: {
      type: String,
      required: true,
      enum: ["1960s", "1970s", "1980s", "1990s", "2000s", "2010s", "2020s"],
    },
    images: [String],
    condition: {
      type: String,
      required: true,
      enum: ["Mint", "Near Mint", "Very Good", "Good", "Fair"],
    },
    rating: {
      type: Number,
      default: 0,
      min: 0,
      max: 5,
    },
    description: {
      type: String,
      default: "",
    },
  },
  { timestamps: true }
);

productSchema.index({ artist: "text", title: "text" });

module.exports = mongoose.model("Product", productSchema);
