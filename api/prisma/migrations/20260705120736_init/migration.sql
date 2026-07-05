-- CreateExtension
CREATE EXTENSION IF NOT EXISTS "postgis";

-- CreateEnum
CREATE TYPE "EateryStatus" AS ENUM ('active', 'closed');

-- CreateEnum
CREATE TYPE "GalleryCategory" AS ENUM ('food', 'drinks', 'desserts', 'interior', 'exterior', 'menu', 'ambience');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "avatarUrl" TEXT,
    "joinedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VenueType" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "VenueType_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Cuisine" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Cuisine_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Eatery" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "areaId" TEXT NOT NULL,
    "address" TEXT,
    "geo" geography(Point, 4326) NOT NULL,
    "description" TEXT,
    "coverPhotoUrl" TEXT,
    "openingHours" TEXT,
    "contact" TEXT,
    "parking" BOOLEAN,
    "indoorSeating" BOOLEAN,
    "outdoorSeating" BOOLEAN,
    "airConditioned" BOOLEAN,
    "familyFriendly" BOOLEAN,
    "wheelchairAccessible" BOOLEAN,
    "status" "EateryStatus" NOT NULL DEFAULT 'active',
    "closedAt" TIMESTAMP(3),
    "closedRememberedFor" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Eatery_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EateryVenueType" (
    "eateryId" TEXT NOT NULL,
    "venueTypeId" TEXT NOT NULL,

    CONSTRAINT "EateryVenueType_pkey" PRIMARY KEY ("eateryId","venueTypeId")
);

-- CreateTable
CREATE TABLE "EateryCuisine" (
    "eateryId" TEXT NOT NULL,
    "cuisineId" TEXT NOT NULL,

    CONSTRAINT "EateryCuisine_pkey" PRIMARY KEY ("eateryId","cuisineId")
);

-- CreateTable
CREATE TABLE "Tag" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Tag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EateryTag" (
    "eateryId" TEXT NOT NULL,
    "tagId" TEXT NOT NULL,

    CONSTRAINT "EateryTag_pkey" PRIMARY KEY ("eateryId","tagId")
);

-- CreateTable
CREATE TABLE "Badge" (
    "id" TEXT NOT NULL,
    "label" TEXT NOT NULL,

    CONSTRAINT "Badge_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EateryBadge" (
    "eateryId" TEXT NOT NULL,
    "badgeId" TEXT NOT NULL,

    CONSTRAINT "EateryBadge_pkey" PRIMARY KEY ("eateryId","badgeId")
);

-- CreateTable
CREATE TABLE "EateryTimelineEvent" (
    "id" TEXT NOT NULL,
    "eateryId" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "eventText" TEXT NOT NULL,

    CONSTRAINT "EateryTimelineEvent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Dish" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "category" TEXT,

    CONSTRAINT "Dish_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MenuVersion" (
    "id" TEXT NOT NULL,
    "eateryId" TEXT NOT NULL,
    "effectiveYear" INTEGER NOT NULL,

    CONSTRAINT "MenuVersion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MenuItem" (
    "id" TEXT NOT NULL,
    "menuVersionId" TEXT NOT NULL,
    "dishId" TEXT,
    "name" TEXT NOT NULL,
    "price" DECIMAL(10,2) NOT NULL,

    CONSTRAINT "MenuItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Visit" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "eateryId" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "time" TEXT,
    "rating" DECIMAL(2,1) NOT NULL,
    "ratingFood" DECIMAL(2,1),
    "ratingService" DECIMAL(2,1),
    "ratingAtmosphere" DECIMAL(2,1),
    "ratingCleanliness" DECIMAL(2,1),
    "ratingValue" DECIMAL(2,1),
    "ratingWaitTime" DECIMAL(2,1),
    "ratingComfort" DECIMAL(2,1),
    "ratingParking" DECIMAL(2,1),
    "ratingWifi" DECIMAL(2,1),
    "ratingStudyFriendly" DECIMAL(2,1),
    "ratingDateFriendly" DECIMAL(2,1),
    "ratingFamilyFriendly" DECIMAL(2,1),
    "reviewText" TEXT,
    "totalBill" DECIMAL(10,2),
    "favoriteItem" TEXT,
    "wouldVisitAgain" BOOLEAN,
    "companions" TEXT,
    "moodTags" TEXT[],
    "memoryNote" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Visit_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VisitItem" (
    "id" TEXT NOT NULL,
    "visitId" TEXT NOT NULL,
    "dishId" TEXT,
    "name" TEXT NOT NULL,
    "type" TEXT NOT NULL,

    CONSTRAINT "VisitItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Photo" (
    "id" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "eateryId" TEXT,
    "visitId" TEXT,
    "galleryCategory" "GalleryCategory" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Photo_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Collection" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "eateryIds" TEXT[],
    "pinned" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Collection_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WishlistEntry" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "eateryId" TEXT NOT NULL,
    "reason" TEXT,
    "recommendedBy" TEXT,
    "priority" INTEGER DEFAULT 0,

    CONSTRAINT "WishlistEntry_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Trail" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "eateryIds" TEXT[],

    CONSTRAINT "Trail_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserTrailProgress" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "trailId" TEXT NOT NULL,
    "visitedEateryIds" TEXT[],

    CONSTRAINT "UserTrailProgress_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Area" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "popularDishes" TEXT[],
    "boundary" geography(Polygon, 4326),

    CONSTRAINT "Area_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "VenueType_name_key" ON "VenueType"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Cuisine_name_key" ON "Cuisine"("name");

-- CreateIndex
CREATE INDEX "Eatery_areaId_idx" ON "Eatery"("areaId");

-- CreateIndex
CREATE UNIQUE INDEX "Tag_name_key" ON "Tag"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Badge_label_key" ON "Badge"("label");

-- CreateIndex
CREATE INDEX "EateryTimelineEvent_eateryId_idx" ON "EateryTimelineEvent"("eateryId");

-- CreateIndex
CREATE UNIQUE INDEX "Dish_name_key" ON "Dish"("name");

-- CreateIndex
CREATE INDEX "MenuVersion_eateryId_idx" ON "MenuVersion"("eateryId");

-- CreateIndex
CREATE INDEX "MenuItem_menuVersionId_idx" ON "MenuItem"("menuVersionId");

-- CreateIndex
CREATE INDEX "MenuItem_dishId_idx" ON "MenuItem"("dishId");

-- CreateIndex
CREATE INDEX "Visit_userId_idx" ON "Visit"("userId");

-- CreateIndex
CREATE INDEX "Visit_eateryId_idx" ON "Visit"("eateryId");

-- CreateIndex
CREATE INDEX "VisitItem_visitId_idx" ON "VisitItem"("visitId");

-- CreateIndex
CREATE INDEX "VisitItem_dishId_idx" ON "VisitItem"("dishId");

-- CreateIndex
CREATE INDEX "Photo_eateryId_idx" ON "Photo"("eateryId");

-- CreateIndex
CREATE INDEX "Photo_visitId_idx" ON "Photo"("visitId");

-- CreateIndex
CREATE INDEX "WishlistEntry_userId_idx" ON "WishlistEntry"("userId");

-- CreateIndex
CREATE INDEX "WishlistEntry_eateryId_idx" ON "WishlistEntry"("eateryId");

-- CreateIndex
CREATE UNIQUE INDEX "UserTrailProgress_userId_trailId_key" ON "UserTrailProgress"("userId", "trailId");

-- CreateIndex
CREATE UNIQUE INDEX "Area_name_key" ON "Area"("name");

-- AddForeignKey
ALTER TABLE "Eatery" ADD CONSTRAINT "Eatery_areaId_fkey" FOREIGN KEY ("areaId") REFERENCES "Area"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EateryVenueType" ADD CONSTRAINT "EateryVenueType_eateryId_fkey" FOREIGN KEY ("eateryId") REFERENCES "Eatery"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EateryVenueType" ADD CONSTRAINT "EateryVenueType_venueTypeId_fkey" FOREIGN KEY ("venueTypeId") REFERENCES "VenueType"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EateryCuisine" ADD CONSTRAINT "EateryCuisine_eateryId_fkey" FOREIGN KEY ("eateryId") REFERENCES "Eatery"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EateryCuisine" ADD CONSTRAINT "EateryCuisine_cuisineId_fkey" FOREIGN KEY ("cuisineId") REFERENCES "Cuisine"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EateryTag" ADD CONSTRAINT "EateryTag_eateryId_fkey" FOREIGN KEY ("eateryId") REFERENCES "Eatery"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EateryTag" ADD CONSTRAINT "EateryTag_tagId_fkey" FOREIGN KEY ("tagId") REFERENCES "Tag"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EateryBadge" ADD CONSTRAINT "EateryBadge_eateryId_fkey" FOREIGN KEY ("eateryId") REFERENCES "Eatery"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EateryBadge" ADD CONSTRAINT "EateryBadge_badgeId_fkey" FOREIGN KEY ("badgeId") REFERENCES "Badge"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EateryTimelineEvent" ADD CONSTRAINT "EateryTimelineEvent_eateryId_fkey" FOREIGN KEY ("eateryId") REFERENCES "Eatery"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MenuVersion" ADD CONSTRAINT "MenuVersion_eateryId_fkey" FOREIGN KEY ("eateryId") REFERENCES "Eatery"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MenuItem" ADD CONSTRAINT "MenuItem_menuVersionId_fkey" FOREIGN KEY ("menuVersionId") REFERENCES "MenuVersion"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MenuItem" ADD CONSTRAINT "MenuItem_dishId_fkey" FOREIGN KEY ("dishId") REFERENCES "Dish"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Visit" ADD CONSTRAINT "Visit_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Visit" ADD CONSTRAINT "Visit_eateryId_fkey" FOREIGN KEY ("eateryId") REFERENCES "Eatery"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VisitItem" ADD CONSTRAINT "VisitItem_visitId_fkey" FOREIGN KEY ("visitId") REFERENCES "Visit"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VisitItem" ADD CONSTRAINT "VisitItem_dishId_fkey" FOREIGN KEY ("dishId") REFERENCES "Dish"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Photo" ADD CONSTRAINT "Photo_eateryId_fkey" FOREIGN KEY ("eateryId") REFERENCES "Eatery"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Photo" ADD CONSTRAINT "Photo_visitId_fkey" FOREIGN KEY ("visitId") REFERENCES "Visit"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Collection" ADD CONSTRAINT "Collection_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WishlistEntry" ADD CONSTRAINT "WishlistEntry_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WishlistEntry" ADD CONSTRAINT "WishlistEntry_eateryId_fkey" FOREIGN KEY ("eateryId") REFERENCES "Eatery"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserTrailProgress" ADD CONSTRAINT "UserTrailProgress_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserTrailProgress" ADD CONSTRAINT "UserTrailProgress_trailId_fkey" FOREIGN KEY ("trailId") REFERENCES "Trail"("id") ON DELETE CASCADE ON UPDATE CASCADE;
