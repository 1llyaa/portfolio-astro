import type { ImageMetadata } from "astro";
import clutchzone from "../assets/case-studies/clutchzone.png";
import dentiyak from "../assets/case-studies/dentiyak.png";

export interface CaseStudy {
	year: string;
	status: string;
	title: string;
	tags: string[];
	description: string[];
	link?: { href: string; label: string };
	image?: { src: ImageMetadata; alt: string };
}

export const caseStudies: CaseStudy[] = [
	{
		year: "2025",
		status: "Offline",
		title: "identkosmetika.cz",
		tags: ["Shopify", "Liquid", "Front end"],
		description: [
			"Cosmetics storefront on Shopify. I owned the front end: theme structure, product templates, and the merchandising rules the stock theme couldn't express.",
			"The store has since been taken offline by the client, so there's nothing live to show. The work was in the theme layer rather than the brand.",
		],
	},
	{
		year: "2026",
		status: "Pre-launch",
		title: "Dentiyak",
		tags: ["Dental clinic", "Multilingual", "AI-directed build"],
		link: { href: "https://clinic.miloserdov.cz", label: "Preview" },
		image: { src: dentiyak, alt: "Dentiyak clinic site homepage" },
		description: [
			"Site for a dental clinic, built by giving coding agents domain-informed instructions: I specified the patient-facing flows and the content model, reviewed every diff, and kept the scope inside what a small clinic can maintain itself.",
			"Built and reviewed, waiting on the clinic to launch. The structure is led by what patients actually call about (accepting new patients, opening hours, phone number) rather than by a services page nobody reads.",
		],
	},
	{
		year: "2026",
		status: "Live",
		title: "clutchzone.club",
		tags: ["Supabase", "Postgres", "Auth · RLS", "Admin UI"],
		link: { href: "https://clutchzone.club", label: "Visit site" },
		image: { src: clutchzone, alt: "Clutch Zone booking site" },
		description: [
			"Before this, the club had no way to take an online booking at all. Everything happened by phone or at the counter. Now seats, tournaments and private events are reservable online, with the owner's own admin for pricing bundles, on a Supabase back end with row-level security separating staff and owner views.",
			"Event tracking here means funnel events, not calendar entries: how many visitors hit \"reserve\", how many start checkout, where they drop. Bundles and events share one booking record with different pricing rules, so the owner changes a price without touching reservation logic.",
		],
	},
];
