CREATE TABLE `auctions` (
	`id` text PRIMARY KEY NOT NULL,
	`created_at` integer DEFAULT (unixepoch()) NOT NULL,
	`updated_at` integer DEFAULT (unixepoch()) NOT NULL,
	`stall_id` text NOT NULL,
	`user_id` text NOT NULL,
	`product_name` text NOT NULL,
	`description` text NOT NULL,
	`product_type` text DEFAULT 'simple' NOT NULL,
	`currency` text NOT NULL,
	`stock_qty` integer NOT NULL,
	`specs` text,
	`shipping_cost` numeric DEFAULT '0.0' NOT NULL,
	`featured` integer DEFAULT false NOT NULL,
	`is_digital` integer DEFAULT false NOT NULL,
	`parent_id` text,
	`starting_bid_amount` numeric NOT NULL,
	`start_date` integer DEFAULT (unixepoch()) NOT NULL,
	`end_date` integer NOT NULL,
	`status` text NOT NULL,
	FOREIGN KEY (`stall_id`) REFERENCES `stalls`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`parent_id`) REFERENCES `products`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `bids` (
	`id` text PRIMARY KEY NOT NULL,
	`created_at` integer DEFAULT (unixepoch()) NOT NULL,
	`updated_at` integer DEFAULT (unixepoch()) NOT NULL,
	`auction_id` text NOT NULL,
	`user_id` text NOT NULL,
	`bid_amount` numeric NOT NULL,
	`bid_status` text DEFAULT 'pending' NOT NULL,
	FOREIGN KEY (`auction_id`) REFERENCES `auctions`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `categories` (
	`cat_id` text PRIMARY KEY NOT NULL,
	`cat_name` text NOT NULL,
	`description` text NOT NULL,
	`parent_id` text,
	FOREIGN KEY (`parent_id`) REFERENCES `categories`(`cat_id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `digital_products` (
	`product_id` text PRIMARY KEY NOT NULL,
	`license_key` text,
	`download_link` text,
	`mime_type` text,
	`sha256_hash` text,
	`comments` text,
	FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `events` (
	`id` text PRIMARY KEY NOT NULL,
	`created_at` integer DEFAULT (unixepoch()) NOT NULL,
	`updated_at` integer DEFAULT (unixepoch()) NOT NULL,
	`event_author` text NOT NULL,
	`event_kind` integer NOT NULL,
	`event` text NOT NULL,
	FOREIGN KEY (`event_author`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `invoices` (
	`id` text PRIMARY KEY NOT NULL,
	`created_at` integer DEFAULT (unixepoch()) NOT NULL,
	`updated_at` integer DEFAULT (unixepoch()) NOT NULL,
	`order_id` text NOT NULL,
	`total_amount` numeric NOT NULL,
	`invoice_status` text DEFAULT 'pending' NOT NULL,
	`payment_method` text NOT NULL,
	`payment_details` text NOT NULL,
	FOREIGN KEY (`order_id`) REFERENCES `orders`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `order_items` (
	`order_id` text NOT NULL,
	`product_id` text NOT NULL,
	`qty` integer NOT NULL,
	PRIMARY KEY(`order_id`, `product_id`),
	FOREIGN KEY (`order_id`) REFERENCES `orders`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `orders` (
	`id` text PRIMARY KEY NOT NULL,
	`created_at` integer DEFAULT (unixepoch()) NOT NULL,
	`updated_at` integer DEFAULT (unixepoch()) NOT NULL,
	`seller_user_id` text NOT NULL,
	`buyer_user_id` text NOT NULL,
	`status` text DEFAULT 'pending' NOT NULL,
	`shipping_id` text NOT NULL,
	`stall_id` text NOT NULL,
	`address` text NOT NULL,
	`zip` text NOT NULL,
	`city` text NOT NULL,
	`region` text NOT NULL,
	`contact_name` text NOT NULL,
	`contact_phone` text,
	`contact_email` text,
	`observations` text,
	FOREIGN KEY (`seller_user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`buyer_user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`shipping_id`) REFERENCES `shipping`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`stall_id`) REFERENCES `stalls`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `payment_details` (
	`payment_id` text PRIMARY KEY NOT NULL,
	`user_id` text NOT NULL,
	`stall_id` text,
	`payment_method` text NOT NULL,
	`payment_details` text NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`stall_id`) REFERENCES `stalls`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `product_categories` (
	`product_id` text,
	`cat_id` text,
	PRIMARY KEY(`cat_id`, `product_id`),
	FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`cat_id`) REFERENCES `categories`(`cat_id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `product_images` (
	`product_id` text,
	`image_url` text,
	`image_type` text DEFAULT 'gallery' NOT NULL,
	`image_order` integer DEFAULT 0 NOT NULL,
	`created_at` integer DEFAULT (unixepoch()) NOT NULL,
	PRIMARY KEY(`image_url`, `product_id`),
	FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `products` (
	`id` text PRIMARY KEY NOT NULL,
	`created_at` integer DEFAULT (unixepoch()) NOT NULL,
	`updated_at` integer DEFAULT (unixepoch()) NOT NULL,
	`stall_id` text NOT NULL,
	`user_id` text NOT NULL,
	`product_name` text NOT NULL,
	`description` text NOT NULL,
	`product_type` text DEFAULT 'simple' NOT NULL,
	`currency` text NOT NULL,
	`stock_qty` integer NOT NULL,
	`specs` text,
	`shipping_cost` numeric DEFAULT '0.0' NOT NULL,
	`featured` integer DEFAULT false NOT NULL,
	`is_digital` integer DEFAULT false NOT NULL,
	`parent_id` text,
	`price` numeric NOT NULL,
	FOREIGN KEY (`stall_id`) REFERENCES `stalls`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`parent_id`) REFERENCES `products`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `shipping` (
	`id` text PRIMARY KEY NOT NULL,
	`created_at` integer DEFAULT (unixepoch()) NOT NULL,
	`updated_at` integer DEFAULT (unixepoch()) NOT NULL,
	`stall_id` text,
	`user_id` text NOT NULL,
	`name` text NOT NULL,
	`shipping_method` text NOT NULL,
	`shipping_details` text NOT NULL,
	`base_cost` numeric NOT NULL,
	`default` integer DEFAULT false NOT NULL,
	FOREIGN KEY (`stall_id`) REFERENCES `stalls`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `shipping_zones` (
	`shipping_zone_id` text PRIMARY KEY NOT NULL,
	`shipping_id` text NOT NULL,
	`stall_id` text,
	`region_code` text NOT NULL,
	`country_code` text NOT NULL,
	FOREIGN KEY (`shipping_id`) REFERENCES `shipping`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`stall_id`) REFERENCES `stalls`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `stalls` (
	`id` text PRIMARY KEY NOT NULL,
	`created_at` integer DEFAULT (unixepoch()) NOT NULL,
	`updated_at` integer DEFAULT (unixepoch()) NOT NULL,
	`name` text NOT NULL,
	`description` text NOT NULL,
	`currency` text NOT NULL,
	`user_id` text NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `users` (
	`id` text PRIMARY KEY NOT NULL,
	`created_at` integer DEFAULT (unixepoch()) NOT NULL,
	`updated_at` integer DEFAULT (unixepoch()) NOT NULL,
	`name` text,
	`role` text DEFAULT 'pleb' NOT NULL,
	`display_name` text,
	`about` text,
	`image` text,
	`banner` text,
	`nip05` text,
	`lud06` text,
	`lud16` text,
	`website` text,
	`zap_Service` text,
	`last_login` integer DEFAULT (unixepoch()) NOT NULL
);
